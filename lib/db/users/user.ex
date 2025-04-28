defmodule Db.Users.User do
  @moduledoc """
  User schema and authentication.
  """
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession]

  schema "users" do
    pow_user_fields()
    field :role, :string, default: "user"
    field :locale, :string, default: "en"

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  def user_identity_changeset(user_or_changeset, user_identity, attrs, user_id_attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role, :locale])
    |> pow_assent_user_identity_changeset(user_identity, attrs, user_id_attrs)
  end
end
