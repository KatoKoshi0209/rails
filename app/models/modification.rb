class Modification < ApplicationRecord
  belongs_to :user
  belongs_to :attendance

  validates :modify_attendance_time, presence: true
  validates :modify_leave_time, presence: true
  validates :status, presence: true
  validates :modify_reason, presence: true
end
