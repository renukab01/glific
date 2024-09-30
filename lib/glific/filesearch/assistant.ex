defmodule Glific.Filesearch.Assistant do
  @moduledoc """
  Assistant schema that maps openAI assistants
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias __MODULE__

  alias Glific.{
    Filesearch.VectorStore,
    Partners.Organization,
    Repo
  }

  @required_fields [
    :assistant_id,
    :name,
    :organization_id,
    :model,
    :settings
  ]
  @optional_fields [
    :instructions,
    :vector_store_id
  ]

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          assistant_id: String.t() | nil,
          name: String.t() | nil,
          organization_id: non_neg_integer | nil,
          organization: Organization.t() | Ecto.Association.NotLoaded.t() | nil,
          vector_store_id: String.t() | nil,
          vector_store: VectorStore.t() | Ecto.Association.NotLoaded.t() | nil,
          model: String.t() | nil,
          instructions: String.t() | nil,
          settings: map() | nil
        }

  schema "openai_assistants" do
    field :assistant_id, :string
    field :name, :string
    field :model, :string
    field :instructions, :string
    field :settings, :map
    belongs_to :organization, Organization
    belongs_to :vector_store, VectorStore
    timestamps(type: :utc_datetime)
  end

  @doc """
  Standard changeset pattern we use for all data types
  """
  @spec changeset(Assistant.t(), map()) :: Ecto.Changeset.t()
  def changeset(openai_assistant, attrs) do
    openai_assistant
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:assistant_id, :organization_id])
    |> unique_constraint([:name, :organization_id])
  end

  @doc """
  Creates an assistant
  """
  @spec create_assistant(map()) :: {:ok, Assistant.t()} | {:error, Ecto.Changeset.t()}
  def create_assistant(attrs) do
    %Assistant{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Get an assistant
  """
  @spec get_assistant(integer()) :: Assistant.t() | nil
  def get_assistant(id),
    do: Repo.get(Assistant, id)

  @doc """
  Deletes assistant
  """
  @spec delete_assistant(Assistant.t()) ::
          {:ok, Assistant.t()} | {:error, Ecto.Changeset.t()}
  def delete_assistant(%Assistant{} = assistant) do
    Repo.delete(assistant)
  end

  @doc """
  Returns the list of assistants.

  ## Examples

      iex> list_assistants()
      [%Assistant{}, ...]

  """
  @spec list_assistants(map()) :: [Assistant.t()]
  def list_assistants(args) do
    args
    |> Repo.list_filter_query(Assistant, &Repo.opts_with_inserted_at/2, &filter_with/2)
    |> Repo.all()
  end

  @doc """
  Updates a assistant.

  ## Examples

      iex> update_assistant(assistant, %{field: new_value})
      {:ok, %Assistant{}}

      iex> update_assistant(assistant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_assistant(Assistant.t(), map()) ::
          {:ok, Assistant.t()} | {:error, Ecto.Changeset.t()}
  def update_assistant(%Assistant{} = assistant, attrs) do
    assistant
    |> Assistant.changeset(attrs)
    |> Repo.update()
  end

  @spec filter_with(Ecto.Queryable.t(), map()) :: Ecto.Queryable.t()
  defp filter_with(query, filter) do
    query = Repo.filter_with(query, filter)

    Enum.reduce(filter, query, fn
      {:assistant_id, assistant_id}, query ->
        from(q in query, where: q.assistant_id == ^assistant_id)

      _, query ->
        query
    end)
  end
end
