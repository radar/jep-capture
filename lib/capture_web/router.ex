defmodule CaptureWeb.Router do
  use Plug.Router

  plug(Plug.Logger, log: :debug)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  alias Capture.{Response, Responses, Repo}

  plug(:match)
  plug(:dispatch)

  post "/responses" do
    %{
      "survey_id" => survey_id,
      "question_id" => question_id,
      "response_id" => response_id,
      "value" => value
    } = conn.params

    query =
      Response
      |> Responses.for_survey(survey_id)
      |> Responses.for_question(question_id)
      |> Responses.for_response(response_id)

    query
    |> Repo.one()
    |> case do
      nil ->
        %Response{
          survey_id: survey_id,
          question_id: question_id,
          response_id: response_id,
          value: value
        }
        |> Capture.Repo.insert()

      %Response{} = response ->
        query |> Repo.update_all(set: [value: value])
    end

    send_resp(conn, 200, "OK")
  end

  get "/responses" do
    query =
      Response
      |> Responses.for_survey(conn.params["survey_id"])
      |> Responses.for_value(1)
      |> Responses.count_responses()
      |> Repo.one()

    IO.inspect(query, label: "QUERY")
    IO.inspect(conn.params, label: "CONN")

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
