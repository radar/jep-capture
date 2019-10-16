defmodule Capture.Repo.Migrations.Responses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :survey_id, :string 
      add :question_id, :string
      add :response_id, :string
      add :value, :integer
    end
  end
end
