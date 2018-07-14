class LessionLog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :question_logs, dependent: :destroy

  def create_lessionlog
    category = lession.course.category
    @questions = category.questions.order("RAND()").first Settings.lession.page

    @questions.each do |question|
      question_logs.create question_id: question.id,
        answer_id: Settings.question.answer_default
    end
  end

  def update_result questionlogs
    @questionlog_ids = params[:questionlog].keys

    @questionlog_ids.each do |questionlog_id|
      queslog = Questionlog.find_by id: questionlog_id
      queslog.update_attributes answer_id: params[:questionlog][questionlog_id]
    end
    @total = questionlogs.count
    @correct = 0

    questionlog_ids.each do |questionlog_id|
      questionlog = QuestionLog.find_by id: questionlog_id
      answer = Answer.find_by question_id: questionlog.question_id,
        correct: true

      @correct += 1 if questionlog.answer_id == answer.id
    end

    if @correct * 1.0 / @correct > 0.8
      update_attributes pass: true
    else
      update_attributes pass: false
    end
  end

  class << self
    def get_lessionlog question_logs
      @questions = []
      @answers = []

      question_logs.each do |question_log|
        @questions << question_log.question
        @answers << question_log.question.answers.order("RAND()")
      end

      [@questions, @answers]
    end
  end
end
