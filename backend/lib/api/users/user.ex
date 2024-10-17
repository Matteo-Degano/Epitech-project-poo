defmodule Api.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  # import Ecto.Query

  alias Api.Teams

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    many_to_many :teams, Api.Teams.Team, join_through: "teams_users", on_replace: :delete
    belongs_to :role, Api.Role

    timestamps(type: :utc_datetime)
  end

  defimpl Jason.Encoder, for: Api.Users.User do
    def encode(struct, opts) do
      Jason.Encode.map(
        Map.take(struct, [:username, :email, :role_id]),
        opts
      )
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role_id])
    |> validate_required([:username, :email, :password, :role_id])
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
