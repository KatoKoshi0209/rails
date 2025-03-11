class ShiftRequest < ApplicationRecord
  belongs_to :user
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    if start_time >= end_time
      errors.add(:end_time, "は開始時間より後の時間を選択してください")
    end
  end
end

