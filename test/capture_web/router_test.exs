defmodule CaptureWeb.RouterTest do
  use Capture.DataCase
  use Plug.Test

  alias CaptureWeb.Router

  alias Capture.{Repo, Response, Responses}

  @opts Router.init([])

  describe "when survey, question & response_id combo does not exist" do
    test "creates a new record" do
      params = %{
        survey_id: 1,
        question_id: 1,
        response_id: 12345,
        value: 1
      }

      conn =
        conn(:post, "/responses", params)
        |> CaptureWeb.Router.call(@opts)

      assert conn.status == 200

      response =
        Response
        |> Responses.for_survey(1)
        |> Responses.for_question(1)
        |> Repo.one()
        |> IO.inspect(label: "blah")

      assert response.value == 1
    end
  end

   describe "when survey, question & response_id combo does exist" do
    setup do
      %Response{survey_id: 1, question_id: 1, response_id: 12345, value: 1}
      |> Repo.insert!()
      :ok
    end

    test "updates record with new value property" do
      params = %{
        survey_id: 1,
        question_id: 1,
        response_id: 12345,
        value: 2
      }

      conn =
        conn(:post, "/responses", params)
        |> CaptureWeb.Router.call(@opts)

      assert conn.status == 200

      response =
        Response
        |> Responses.for_survey(1)
        |> Responses.for_question(1)
        |> Repo.one()

      assert response.survey_id == 1
      assert response.question_id == 1
      assert response.response_id == 12345
      assert response.value == 2
    end
  end
end
