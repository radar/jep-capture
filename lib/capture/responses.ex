defmodule Capture.Responses do
  import Ecto.Query

  def for_survey(responses, survey_id) do
    responses |> where(survey_id: ^survey_id)
  end

  def for_question(responses, question_id) do
    responses |> where(question_id: ^question_id)
  end

  def for_response(responses, response_id) do
    responses |> where(response_id: ^response_id)
  end

  def for_value(responses, value) do
    responses |> where(value: ^value)
  end

  def count_responses(responses) do
    responses |> select([responses], count(responses.id))
  end

end
