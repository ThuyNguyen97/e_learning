class Answer < ApplicationRecord
  belongs_to :question
  has_many :questionlogs

  validates :content, presence: true
end
