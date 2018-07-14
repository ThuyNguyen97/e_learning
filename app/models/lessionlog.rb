class Lessionlog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :questionlogs, dependent: :destroy

  def create_lessionlog
    @category = lession.course.category
    @questions = @category.questions.order("RAND()").first 30

    @questions.each do |question|
      questionlogs.create question_id: question.id, answer_id: 5
    end
  end

  def update_result questionlog_ids
    @total = questionlogs.count
    @correct = 0

    questionlog_ids.each do |questionlog_id|
      questionlog = Questionlog.find_by id: questionlog_id
      answer = Answer.find_by question_id: questionlog.question_id,
        correct: true

      @correct += 1 if questionlog.answer_id == answer.id
    end

    if (@correct * 1.0 / @total) > 0.8
      update_attributes pass: true
    else
      update_attributes pass: false
    end
  end
end
