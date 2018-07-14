class Lessionlog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :questionlogs, dependent: :destroy
end
