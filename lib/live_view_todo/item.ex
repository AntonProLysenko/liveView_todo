defmodule LiveViewTodo.Item do
  # this schema is created by this command mix phx.gen.schema Item items text:string person_id:integer status:integer
  # this command also creates the migration file for our db
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias LiveViewTodo.Repo
  alias __MODULE__

  schema "items" do
    field :person_id, :integer
    field :status, :integer, default: 0
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:text, :person_id, :status])
    |> validate_required([:text])
  end






  @doc """
Creates a item.

## Examples

    iex> create_item(%{text: "Learn LiveView"})
    {:ok, %Item{}}

    iex> create_item(%{text: nil})
    {:error, %Ecto.Changeset{}}

"""
def create_item(attrs \\ %{}) do
  %Item{}
  |> changeset(attrs)
  |> Repo.insert()
end

@doc """
Gets a single item.

Raises `Ecto.NoResultsError` if the Item does not exist.

## Examples

    iex> get_item!(123)
    %Item{}

    iex> get_item!(456)
    ** (Ecto.NoResultsError)

"""
def get_item!(id), do: Repo.get!(Item, id)


@doc """
Returns the list of items.

## Examples

    iex> list_items()
    [%Item{}, ...]

"""
# def list_items do
#   Repo.all(Item)
# end

def list_items do
  Item
  |> order_by(desc: :inserted_at)
  # |> where([a], is_nil(a.status) or a.status != 2)
  |> Repo.all()
end

@doc """
Updates a item.

## Examples

    iex> update_item(item, %{field: new_value})
    {:ok, %Item{}}

    iex> update_item(item, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_item(%Item{} = item, attrs) do
  item
  |> Item.changeset(attrs)
  |> Repo.update()
end

def delete_item(id) do
  get_item!(id)
  |> Item.changeset(%{status: 2})
  |> Repo.update()
end

#Hard deleting
# def delete_item(id) do
#   get_item!(id)
#   |> Item.changeset(%{status: 2})
#   |> Repo.delete()
# end

def clear_completed() do
  completed_items = from(i in Item, where: i.status == 1)
  Repo.update_all(completed_items, set: [status: 2])
end

end
