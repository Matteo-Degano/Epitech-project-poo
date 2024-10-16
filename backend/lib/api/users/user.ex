defmodule Api.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    field(:team, :string)
    field(:role, Ecto.Enum, values: [:user, :manager, :admin])

    timestamps(type: :utc_datetime)
  end

  defimpl Jason.Encoder, for: Api.Users.User do
    def encode(struct, opts) do
      Jason.Encode.map(
        Map.take(struct, [:username, :email, :team, :role]),
        opts
      )
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :team, :role])
    |> validate_required([:username, :email, :password, :team, :role])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
