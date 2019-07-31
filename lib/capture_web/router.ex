defmodule CaptureWeb.Router do
  use Plug.Router

  plug Plug.Logger, log: :debug
  plug Plug.Parsers, parsers: [:urlencoded, :json],
  json_decoder: Jason

  plug :match
  plug :dispatch

  alias Capture.{Response, Responses, Repo}

  post "/responses" do
    %{"survey_id" => survey_id, "question_id" => question_id, "selected_answer" => selected_answer} = conn.params

    query = Response
    |> Responses.for_survey(survey_id)
    |> Responses.for_question(question_id)

    query
    |> Repo.one
    |> case do
      nil ->
        %Response{survey_id: survey_id, question_id: question_id}
        |> Map.merge(%{convertSelectedAnswer(selected_answer) => 1})
        |> Capture.Repo.insert
      %Response{} = response ->
        update = %{convertSelectedAnswer(selected_answer) => 1} |> Keyword.new
        Repo.update_all(query, inc: update)
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
