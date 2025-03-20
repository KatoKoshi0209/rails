class Absence < ApplicationRecord
  belongs_to :user
  belongs_to :shift

  validates :status, presence: true
end
