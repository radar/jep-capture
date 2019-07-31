defmodule CaptureWeb.RouterTest do
  use Capture.DataCase
  use Plug.Test

  alias CaptureWeb.Router

  alias Capture.{Repo, Response, Responses}

  @opts Router.init([])

  test "takes a response from a user" do
    params = %{
      survey_id: 3,
      question_id: 1,
      response_id: 1,
      value: 5,
    }

    conn = conn(:post, "/responses", params)
    |> CaptureWeb.Router.call(@opts)

    assert conn.status == 200

    response = Response
    |> Responses.for_survey(3)
    |> Responses.for_question(1)
    |> Responses.for_response(1)
    |> Repo.one

    assert response.value == 5
  end

  describe "with an existing response" do
    setup do
      %Response{survey_id: 1, question_id: 1, response_id: 123, value: 1}
      |> Repo.insert!()
      :ok
    end
      test "updates the value" do

        params = %{
          survey_id: 1,
          question_id: 1,
          response_id: 123,
          value: 5,
        }

        conn = conn(:post, "/responses", params)
        |> CaptureWeb.Router.call(@opts)

        assert conn.status == 200

        response = Response
        |> Responses.for_survey(1)
        |> Responses.for_question(1)
        |> Responses.for_response(123)
        |> Repo.one

        assert response.value == 5
      end
  end
end
