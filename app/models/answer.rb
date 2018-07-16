class Answer < ApplicationRecord
  belongs_to :question
  has_many :question_logs

  validates :content, presence: true

  class << self
    def get_correct_answers answers
      @corrects = []

      answers.each do |answer|
        @corrects.push (answer.find_by correct: true).id
      end
      return @corrects
    end    
  end
end
