defmodule Glific.Registrations do
  @moduledoc """
  The Registrations context
  """

  alias Glific.{
    Registrations.Registration,
    Repo
  }

  @doc """
  Creates a organization.

  ## Examples

      iex> Glific.Registrations.create_registration(%{organization_id: 1})
      {:ok, %Registration{}}

      iex> Glific.Registrations.create_registration(%{})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_registration(map()) :: {:ok, Registration.t()} | {:error, Ecto.Changeset.t()}
  def create_registration(attrs \\ %{}) do
    %Registration{}
    |> Registration.changeset(attrs)
    |> Repo.insert()
  end

  @spec fetch_registration(integer()) :: {:ok, Registration.t()} | {:error, term()}
  def fetch_registration(registration_id) do
    Repo.fetch_by(Registration, id: registration_id)
  end

  @spec update_registation(Registration.t(), map()) ::
          {:ok, Registration.t()} | {:error, Ecto.Changeset.t()}
  def update_registation(registration, attrs) do
    registration
    |> Registration.changeset(attrs)
    |> Repo.update()
  end
end
