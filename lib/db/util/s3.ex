defmodule Db.Util.S3 do
  @moduledoc """
  Dependency-free S3 Form Upload using HTTP POST sigv4
  https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-post-example.html
  """

  @doc """
  Signs a form upload.
  The configuration is a map which must contain the following keys:
    * `:region` - The AWS region, such as "us-east-1"
    * `:access_key_id` - The AWS access key id
    * `:secret_access_key` - The AWS secret access key
  Returns a map of form fields to be used on the client via the JavaScript `FormData` API.
  ## Options
    * `:key` - The required key of the object to be uploaded.
    * `:max_file_size` - The required maximum allowed file size in bytes.
    * `:content_type` - The required MIME type of the file to be uploaded.
    * `:expires_in` - The required expiration time in milliseconds from now
      before the signed upload expires.
  ## Examples
      {:ok, fields} =
        S3.sign_form_upload(
          key: "public/my-file-name",
          content_type: "image/png",
          max_file_size: 10_000,
          expires_in: :timer.hours(1)
        )
  """
  def sign_form_upload(opts) do
    key = Keyword.fetch!(opts, :key)
    max_file_size = Keyword.fetch!(opts, :max_file_size)
    content_type = Keyword.fetch!(opts, :content_type)
    expires_in = Keyword.fetch!(opts, :expires_in)

    expires_at = DateTime.add(DateTime.utc_now(), expires_in, :millisecond)
    amz_date = amz_date(expires_at)
    credential = credential(config(), expires_at)

    encoded_policy =
      Base.encode64("""
      {
        "expiration": "#{DateTime.to_iso8601(expires_at)}",
        "conditions": [
          {"bucket":  "#{bucket()}"},
          ["eq", "$key", "#{key}"],
          {"acl": "public-read"},
          ["eq", "$Content-Type", "#{content_type}"],
          ["content-length-range", 0, #{max_file_size}],
          {"x-amz-server-side-encryption": "AES256"},
          {"x-amz-credential": "#{credential}"},
          {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
          {"x-amz-date": "#{amz_date}"}
        ]
      }
      """)

    fields = %{
      "key" => key,
      "acl" => "public-read",
      "content-type" => content_type,
      "x-amz-server-side-encryption" => "AES256",
      "x-amz-credential" => credential,
      "x-amz-algorithm" => "AWS4-HMAC-SHA256",
      "x-amz-date" => amz_date,
      "policy" => encoded_policy,
      "x-amz-signature" => signature(config(), expires_at, encoded_policy)
    }

    {:ok, fields}
  end

  defp config do
    %{
      region: region(),
      access_key_id: Application.fetch_env!(:db, :access_key_id),
      secret_access_key: Application.fetch_env!(:db, :secret_access_key)
    }
  end

  def meta(entry, uploads) do
    s3_filepath = s3_filepath(entry)

    {:ok, fields} =
      sign_form_upload(
        key: s3_filepath,
        content_type: entry.client_type,
        max_file_size: uploads.photo.max_file_size,
        expires_in: :timer.hours(1)
      )

    %{
      uploader: "S3",
      key: s3_filepath,
      url: "https://#{bucket()}.#{url()}",
      fields: fields
    }
  end

  def bucket do
    Application.fetch_env!(:db, :bucket)
  end

  def region do
    Application.fetch_env!(:db, :region)
  end

  def url do
    Application.fetch_env!(:db, :url)
  end

  def s3_filepath(entry) do
    "#{entry.uuid}.#{ext(entry)}"
  end

  def entry_url(entry) do
    "http://#{bucket()}.s3.#{region()}.amazonaws.com/#{entry.uuid}.#{ext(entry)}"
  end

  def presign_entry(entry, socket) do
    uploads = socket.assigns.uploads
    s3_filepath = s3_filepath(entry)

    {:ok, fields} =
      sign_form_upload(
        key: s3_filepath,
        content_type: entry.client_type,
        max_file_size: uploads.photo.max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{
      uploader: "S3",
      key: s3_filepath,
      url: "https://#{bucket()}.s3.amazonaws.com",
      fields: fields
    }

    {:ok, meta, socket}
  end

  def ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp amz_date(time) do
    time
    |> NaiveDateTime.to_iso8601()
    |> String.split(".")
    |> List.first()
    |> String.replace("-", "")
    |> String.replace(":", "")
    |> Kernel.<>("Z")
  end

  defp credential(%{} = config, %DateTime{} = expires_at) do
    "#{config.access_key_id}/#{short_date(expires_at)}/#{config.region}/s3/aws4_request"
  end

  defp signature(config, %DateTime{} = expires_at, encoded_policy) do
    config
    |> signing_key(expires_at, "s3")
    |> sha256(encoded_policy)
    |> Base.encode16(case: :lower)
  end

  defp signing_key(%{} = config, %DateTime{} = expires_at, service) when service in ["s3"] do
    amz_date = short_date(expires_at)
    %{secret_access_key: secret, region: region} = config

    ("AWS4" <> secret)
    |> sha256(amz_date)
    |> sha256(region)
    |> sha256(service)
    |> sha256("aws4_request")
  end

  defp short_date(%DateTime{} = expires_at) do
    expires_at
    |> amz_date()
    |> String.slice(0..7)
  end

  defp sha256(secret, msg), do: :crypto.mac(:hmac, :sha256, secret, msg)
end
