class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :questionLogs, dependent: :destroy

  validates :meaning, presence: true
  validates :content, presence: true
end
