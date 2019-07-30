defmodule Capture.Response do
  use Ecto.Schema

  schema "responses" do
    field(:survey_id, :integer)
    field(:question_id, :integer)
    field(:strongly_disagree, :integer)
    field(:disagree, :integer)
    field(:neutral, :integer)
    field(:agree, :integer)
    field(:strongly_agree, :integer)
  end
end
