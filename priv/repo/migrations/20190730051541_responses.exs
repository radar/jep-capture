defmodule Capture.Repo.Migrations.Responses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :survey_id, :integer
      add :question_id, :integer
      add :strongly_agree, :integer
      add :agree, :integer
      add :neutral, :integer
      add :disagree, :integer
      add :strongly_disagree, :integer
    end
  end
end
