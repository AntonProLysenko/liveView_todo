defmodule LiveViewTodo.Item do
  # this schema is created by this command mix phx.gen.schema Item items text:string person_id:integer status:integer
  # this command also creates the migration file for our db
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :status, :integer
    field :text, :string
    field :person_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:text, :person_id, :status])
    |> validate_required([:text, :person_id, :status])
  end
end
