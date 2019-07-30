defmodule CaptureWeb.Router do
  use Plug.Router

  alias Capture.{Response, Responses, Repo}

  plug(:match)
  plug(:dispatch)

  post "/responses" do
    %{
      "survey_id" => survey_id,
      "question_id" => question_id,
      "previous_response_id" => previous_response_id,
      "response_id" => response_id
    } = conn.params

    query =
      Response
      |> Responses.for_survey(survey_id)
      |> Responses.for_question(question_id)
      # |> Responses.for_response(response_id)

    # previous_response_query =
    #   Response
    #   |> Responses.for_survey(survey_id)
    #   |> Responses.for_question(question_id)
    #   |> Responses.for_response(previous_response_id)

    query
    |> Repo.one()
    |> case do
      nil ->
        %Response{survey_id: survey_id, question_id: question_id, response_id: response_id, value: 1}
        |> Capture.Repo.insert()

      %Response{} = response ->
        case previous_response_id do
          nil ->
            update = %{:value => 1} 
            |> Keyword.new() 
            Repo.update_all(query |> Responses.for_response(response_id), inc: update) 
          _ ->
            update = %{:value => 1} 
            |> Keyword.new() 
            Repo.update_all(query |> Responses.for_response(response_id).first |> Repo.one, inc: update) 
            # Fix this error
            
            # previous_response_update = %{:value => (-1)} |> Keyword.new() 
            # Repo.update_all(query |> Responses.for_response(previous_response_id), inc: previous_response_update)
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
