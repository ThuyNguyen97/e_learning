class CreateQuestionLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :questionLogs do |t|
      t.references :lessionLog, foreign_key: true
      t.references :question, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
