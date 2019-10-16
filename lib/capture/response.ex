defmodule Capture.Response do
  use Ecto.Schema

  schema "responses" do
    field(:survey_id, :string)
    field(:question_id, :string)
    field(:response_id, :string)
    field(:value, :integer)
  end
end
