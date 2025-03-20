class Absence < ApplicationRecord
  belongs_to :user
  belongs_to :shift

  validates :status, presence: true
  validates :absence_reason, presence: true
end
