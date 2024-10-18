defmodule Api.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    belongs_to :team, Api.Team
    belongs_to :role, Api.Role

    timestamps(type: :utc_datetime)
  end

  defimpl Jason.Encoder, for: Api.Users.User do
    def encode(struct, opts) do
      Jason.Encode.map(
        Map.take(struct, [:id, :username, :email, :team_id, :role_id]),
        opts
      )
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :username, :email, :password, :team_id, :role_id])
    |> validate_required([:username, :email, :password, :team_id, :role_id])
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:role_id)
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
