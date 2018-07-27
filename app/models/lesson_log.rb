class LessonLog < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  has_many :question_logs, dependent: :destroy

  scope :order_date, ->(cond){order created_at: cond}
  scope :current, ->(current_user){where(user_id: current_user)}
  scope :pass_lesson, ->{where(pass: true)}

  after_create :create_question_log

  def create_question_log
    QuestionLog.create_question_logs
  end

  def update_result status
    if status.eql? I18n.t("save")
      update_attributes saved: true
    else
      update_pass
    end
  end

  def update_pass
    update_attributes pass:
      get_result > Settings.number.enought_to_pass
    update_attributes saved: false
  end

  def get_result
    question_logs = self.question_logs
    total = Question.get_ques_by_ids(question_logs.pluck :question_id).size
    uncorrect = []
    answers = question_logs.preload :answer
    questions = question_logs.preload :question

    answers.size.times do |i|
      if answers[i].answer.correct && answers[i].number.zero?
        uncorrect.push questions[i].question.id
      end
    end
    score = (total - uncorrect.uniq.size) * Settings.number.one_float / total
    score
  end

  class << self
    def get_lesson_log question_logs
      @questions = []
      @answers = []

      question_logs.each do |question_log|
        @questions.push question_log.question.id
        @answers.push question_log.question.answers.order "RAND()"
      end

      [@questions, @answers]
    end

    def get_results lesson_logs
      results = []

      lesson_logs.preload(:question_logs).each do |ll|
        question_log = ll.question_logs
        total = Question.get_ques_by_ids(question_log.select :question_id).size
        results.push(if ll.pass.nil?
                       ""
                     else
                       "#{(ll.get_result * total).to_i} / #{total}"
                     end)
      end
      results
    end
  end

  private

  attr_reader :lesson_log
end
