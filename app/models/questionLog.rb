class QuestionLog < ApplicationRecord
  belongs_to :lessionLog
  belongs_to :question
  belongs_to :answer
end
