class Shift < ApplicationRecord
  belongs_to :user
  has_many :absences, dependent: :nullify
end
