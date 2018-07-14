class Answer < ApplicationRecord
  belongs_to :question
  has_many :questionLogs

  validates :content, presence: true
end
