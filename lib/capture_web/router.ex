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

  def query_selector(responses, "" <> question_id) do
      responses
      |> Responses.for_question(question_id)
  end

  def query_selector(responses, _) do
      responses
  end

  get "/responses" do
    question_id = conn.params["question_id"]

    tally =
      Enum.map([1, 2, 3, 4, 5], fn value ->
        Response
        |> Responses.for_survey(conn.params["survey_id"])
        |> query_selector(question_id)
        |> Responses.for_value(value)
        |> Responses.count_responses()
        |> Repo.one()
      end)

    response_body =
      '{"strongly-disagree": #{Enum.at(tally, 0)}, "disagree": #{Enum.at(tally, 1)}, "neutral": #{
        Enum.at(tally, 2)
      },
    "agree": #{Enum.at(tally, 3)}, "strongly-agree": #{Enum.at(tally, 4)}}'

    resp(conn, 200, response_body)
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
