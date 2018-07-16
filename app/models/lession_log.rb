class LessionLog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :question_logs, dependent: :destroy

  def create_lession_log
    category = lession.course.category
    @questions = category.questions.order("RAND()").first Settings.lession.page

    @questions.each do |question|
      question_logs.create question_id: question.id,
        answer_id: Settings.question.answer_default
    end
  end

  def update_result question_logs
    @total = question_logs.keys.count
    @correct = 0

    question_logs.keys.each do |question_log_id|
      quesstion_log = QuestionLog.find_by id: question_log_id
      quesstion_log.update_attributes answer_id: question_logs[question_log_id]
      @correct += 1 if quesstion_log.answer.correct
    end

    if (@correct * 1.0 / @correct) > 0.8
      update_attributes pass: true
    else
      update_attributes pass: false
    end
  end

  class << self
    def get_lession_log question_logs
      @questions = []
      @answers = []

      question_logs.each do |question_log|
        @questions.push question_log.question
        @answers.push question_log.question.answers.order("RAND()")
      end

      [@questions, @answers]
    end
  end
end
