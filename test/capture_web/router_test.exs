defmodule CaptureWeb.RouterTest do
  use Capture.DataCase
  use Plug.Test

  alias CaptureWeb.Router

  alias Capture.{Repo, Response, Responses}

  @opts Router.init([])

  describe "with a response already" do
    setup do
      %Response{survey_id: 1, question_id: 1, value: 3, response_id: 5}
      |> Repo.insert!()

      :ok
    end

    test "updates the existing record" do
      params = %{
        survey_id: 1,
        question_id: 1,
        previous_response_id: nil,
        response_id: 5
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

      assert response.value == 4
    end
  end

  describe "with no responses" do
    test "creates a record" do
      params = %{
        survey_id: 1,
        question_id: 1,
        previous_response_id: nil,
        response_id: 2
      }

      conn =
        conn(:post, "/responses", params)
        |> CaptureWeb.Router.call(@opts)

      assert conn.status == 200

      response =
        Response
        |> Responses.for_survey(1)
        |> IO.inspect(label: "before")
        |> Responses.for_question(1)
        |> IO.inspect(label: "middle")
        |> Repo.one()
        |> IO.inspect(label: "after")

      assert response.survey_id == 1
      assert response.question_id == 1
      assert response.response_id == 2
    end
  end
   describe "with an updated response" do
    setup do
      %Response{survey_id: 1, question_id: 1, value: 1, response_id: 2}
      |> Repo.insert!()

      %Response{survey_id: 1, question_id: 1, value: 1, response_id: 3}
      |> Repo.insert!()

      :ok
    end

    test "updates the database with the correct response amount" do
      params = %{
        survey_id: 1,
        question_id: 1,
        previous_response_id: 2,
        response_id: 3
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
      assert response.previous_response_id == 2
      assert response.response_id == 3
    end
  end
end
