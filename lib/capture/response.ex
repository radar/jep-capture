defmodule Capture.Response do
  use Ecto.Schema

  schema "responses" do
    field(:survey_id, :integer)
    field(:question_id, :integer)
    field(:response_id, :integer)
    field(:value, :integer)
  end
end
