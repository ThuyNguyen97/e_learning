class Lession < ApplicationRecord
  belongs_to :course
  has_many :lessionlogs, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.lession.length.max_name}
end
