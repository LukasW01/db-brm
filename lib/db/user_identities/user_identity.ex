defmodule Db.UserIdentities.UserIdentity do
  @moduledoc """
  User identities (from OAuth-Provider)
  """
  use Ecto.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: Db.Users.User

  schema "user_identities" do
    pow_assent_user_identity_fields()

    timestamps()
  end
end
