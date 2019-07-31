defmodule CaptureWeb.Router do
  use Plug.Router

  plug Plug.Logger, log: :debug
  plug Plug.Parsers, parsers: [:urlencoded, :json],
  json_decoder: Jason

  plug :match
  plug :dispatch

  alias Capture.{Response, Responses, Repo}

  def handle_response(%Plug.Conn{
    params: %{
      "survey_id" => survey_id,
      "question_id" => question_id,
      "response_id" => response_id,
      "value" => value
    }
  } = conn) do
    query = Response
    |> Responses.for_survey(survey_id)
    |> Responses.for_question(question_id)
    |> Responses.for_response(response_id)

    query
    |> Repo.one
    |> case do
      nil ->
        %Response{survey_id: survey_id, question_id: question_id, response_id: response_id, value: value}
        |> Capture.Repo.insert
      %Response{} = response ->
        response
        |> Response.changeset(%{value: value})
        |> Repo.update
    end

    conn
  end

  post "/responses" do
    send_resp(conn |> handle_response, 200, "OK")
  end

  def convert_answer(answer) do
    case answer do
      1 -> :strongly_disagree
      2 -> :disagree
      3 -> :neutral
      4 -> :agree
      5 -> :strongly_agree
    end
  end
end
