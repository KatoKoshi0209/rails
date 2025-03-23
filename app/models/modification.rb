class Modification < ApplicationRecord
  belongs_to :user
  belongs_to :attendance

  validates :modify_attendance_time, presence: { message: "この項目は必須です" }
  validates :modify_leave_time, presence: { message: "この項目は必須です" }
  validates :status, presence: { message: "この項目は必須です" }
  validates :modify_reason, presence: { message: "この項目は必須です" }
end
