class Absence < ApplicationRecord
  belongs_to :user
  belongs_to :shift

  validates :status, presence: true
  validates :absence_reason, presence: { message: "この項目は必須です" }
end
