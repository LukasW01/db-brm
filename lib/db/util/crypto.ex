# credo:disable-for-this-file Credo.Check.Refactor.Nesting
defmodule Db.Crypto do
  @moduledoc """
  Streaming AES-256-CTR file encryption and decryption using Erlang's :crypto API.

  ## Usage

  iex> Db.Crypto.encrypt("input.txt", "encrypted.bin")
  :ok

  iex> Db.Crypto.decrypt("encrypted.bin", "output.txt")
  :ok
  """

  @chunk_size 50 * 1024 * 1024
  @aes :aes_256_ctr
  @iv :crypto.strong_rand_bytes(16)

  @doc """
  Encrypts `input_path` into `output_path` with the given 32-byte key.
  Writes the 16-byte IV at the start of the file.
  """
  def encrypt(input_file, output_file) do
    File.open!(output_file, [:write], fn output ->
      IO.binwrite(output, @iv)

      cipher =
        :crypto.crypto_init(
          @aes,
          Base.decode64!(Application.get_env(:db, :encryption_key)),
          @iv,
          true
        )

      File.stream!(input_file, [], @chunk_size)
      |> Enum.each(fn chunk ->
        ciphertext = :crypto.crypto_update(cipher, chunk)
        IO.binwrite(output, ciphertext)
      end)

      IO.binwrite(output, :crypto.crypto_final(cipher))
    end)
  end

  @doc """
  Decrypts `input_file` into `output_file` using AES-256-CTR with the given 32-byte key.
  Reads the 16-byte initialization vector (IV) from the start of the input file.
  """
  def decrypt(input_file, output_file) do
    File.open!(input_file, [:read], fn input ->
      @iv = get_iv(input)

      cipher =
        :crypto.crypto_init(
          @aes,
          Base.decode64!(Application.get_env(:db, :encryption_key)),
          @iv,
          false
        )

      File.open!(output_file, [:write], fn output ->
        IO.binstream(input, @chunk_size)
        |> Enum.each(fn chunk ->
          plaintext = :crypto.crypto_update(cipher, chunk)
          IO.binwrite(output, plaintext)
        end)
      end)
    end)
  end

  defp get_iv(file) do
    case IO.binread(file, 16) do
      :eof ->
        {:error, "Encrypted file is empty, cannot read IV"}

      {:error, reason} ->
        {:error, "Unexpected error reading 16-byte IV: #{inspect(reason)}"}

      iv when is_binary(iv) ->
        iv

      other ->
        {:error, "Unexpected return from IO.binread/2: #{inspect(other)}"}
    end
  end
end
