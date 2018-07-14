class CreateQuestionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :questionlogs do |t|
      t.references :lessionlog, foreign_key: true
      t.references :question, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
