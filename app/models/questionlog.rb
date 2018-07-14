class Questionlog < ApplicationRecord
  belongs_to :lessionlog
  belongs_to :question
  belongs_to :answer
end
