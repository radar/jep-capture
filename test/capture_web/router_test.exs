defmodule CaptureWeb.RouterTest do
  use Capture.DataCase
  use Plug.Test

  alias CaptureWeb.Router

  alias Capture.{Repo, Response, Responses}

  @opts Router.init([])

  describe "with a response already" do
    setup do
      %Response{survey_id: 1, question_id: 1, strongly_agree: 3}
      |> Repo.insert!()

      :ok
    end

    test "updates the existing record" do
      params = %{
        survey_id: 1,
        question_id: 1,
        previous_answer: nil,
        selected_answer: 5
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

      assert response.strongly_agree == 4
    end
  end

  describe "with no responses" do
    test "creates a record" do
      params = %{
        survey_id: 1,
        question_id: 1,
        previous_answer: nil,
        selected_answer: 2
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
      assert response.disagree == 1
    end
  end

  describe "with an updated response" do
    setup do
      %Response{survey_id: 1, question_id: 1, disagree: 1, neutral: 1}
      |> Repo.insert!()

      :ok
    end

    test "updates the database with the correct response amount" do
      params = %{
        survey_id: 1,
        question_id: 1,
        previous_answer: 2,
        selected_answer: 3
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
      assert response.disagree == 0
      assert response.neutral == 2
    end
  end
end
