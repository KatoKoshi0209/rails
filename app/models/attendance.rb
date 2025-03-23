class Attendance < ApplicationRecord
  belongs_to :user
  has_many :modifications

  # バリデーションの追加
  validates :attendance_time, presence: { message: "この項目は必須です" }
  validates :leave_time, presence: { message: "この項目は必須です" }

  # 退勤時間は出勤時間より後であることを確認
  validate :leave_time_after_attendance_time

  # 休憩開始時間は退勤時間より前であることを確認
  validate :break_start_time_before_leave_time

  private

  # 退勤時間が出勤時間より後であることを確認するカスタムバリデーション
  def leave_time_after_attendance_time
    if leave_time.present? && attendance_time.present? && leave_time <= attendance_time
      errors.add(:leave_time, '退勤時間は出勤時間より後でなければなりません')
    end
  end

  # 休憩開始時間が退勤時間より前であることを確認するカスタムバリデーション
  def break_start_time_before_leave_time
    if break_start_time.present? && leave_time.present? && break_start_time >= leave_time
      errors.add(:break_start_time, '休憩開始時間は退勤時間より前でなければなりません')
    end
  end
end
