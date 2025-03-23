class Shift < ApplicationRecord
  belongs_to :user
  has_many :absences, dependent: :nullify

  validates :user_id, presence: { message: "この項目は必須です" }
  validates :date, presence: { message: "この項目は必須です" }
  validates :start_time, presence: { message: "この項目は必須です" }
  validates :end_time, presence: { message: "この項目は必須です" }
  validate :end_time_after_start_time

  private

  # 開始時間が終了時間より前であることを確認する
  def end_time_after_start_time
    if start_time.present? && end_time.present? && end_time <= start_time
      errors.add(:end_time, "終了時間は開始時間より後でなければなりません")
    end
  end
end
