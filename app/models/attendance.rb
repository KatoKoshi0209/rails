class Attendance < ApplicationRecord
  belongs_to :user
  has_many :modifications
end
