defmodule Capture.Response do
  use Ecto.Schema

  schema "responses" do
    field :survey_id, :integer
    field :question_id, :integer
    field :response_id, :integer
    field :value, :integer

    def changeset(response, params \\ %{}) do
      response
      |> Ecto.Changeset.change(params)
    end
  end
end
