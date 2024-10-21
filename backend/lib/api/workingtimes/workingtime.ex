defmodule Api.Workingtimes.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field(:start, :naive_datetime)
    field(:end, :naive_datetime)
    field(:user_id, :id)

    timestamps(type: :utc_datetime)
  end

  defimpl Jason.Encoder, for: Api.Workingtimes.Workingtime do
    def encode(struct, opts) do
      Jason.Encode.map(Map.take(struct, [:id, :start, :end, :user_id, :inserted_at, :updated_at]), opts)
    end
  end


  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:start, :end, :user_id])
  end
end
