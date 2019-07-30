defmodule CaptureWeb.Router do
  use Plug.Router

  alias Capture.{Response, Responses, Repo}

  plug(:match)
  plug(:dispatch)

  post "/responses" do
    %{
      "survey_id" => survey_id,
      "question_id" => question_id,
      "previous_answer" => previous_answer,
      "selected_answer" => selected_answer
    } = conn.params

    query =
      Response
      |> Responses.for_survey(survey_id)
      |> Responses.for_question(question_id)

    query
    |> Repo.one()
    |> case do
      nil ->
        %Response{survey_id: survey_id, question_id: question_id}
        |> Map.merge(%{convertSelectedAnswer(selected_answer) => 1})
        |> Capture.Repo.insert()

      %Response{} = response ->
        case previous_answer do
          nil ->
            update = %{convertSelectedAnswer(selected_answer) => 1} |> Keyword.new() 
            Repo.update_all(query, inc: update)
          _ ->
            update = %{convertSelectedAnswer(selected_answer) => 1, convertSelectedAnswer(previous_answer) => (-1)} |> Keyword.new() 
            Repo.update_all(query, inc: update)
        end
    end

    send_resp(conn, 200, "OK")
  end

  def convertSelectedAnswer(answer) do
    case answer do
      1 -> :strongly_disagree
      2 -> :disagree
      3 -> :neutral
      4 -> :agree
      5 -> :strongly_agree
    end
  end
end
