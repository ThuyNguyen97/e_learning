class Course < ApplicationRecord
  belongs_to :category
  has_many :followcourses, dependent: :destroy
  has_many :lessions, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.course.length.max_name}
end
