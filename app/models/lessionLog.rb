class LessionLog < ApplicationRecord
  belongs_to :user
  belongs_to :lession
  has_many :questionLogs, dependent: :destroy
end
