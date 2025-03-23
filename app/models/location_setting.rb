class LocationSetting < ApplicationRecord
  validates :office_name, presence: { message: "拠点名は必須です" }
  validates :latitude, presence: { message: "緯度は必須です" }
  validates :longitude, presence: { message: "経度は必須です" }
  validates :radius, presence: { message: "拠点からの距離は必須です" }

  # 数値の範囲を設定（例えば、緯度と経度は適切な範囲にする）
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, message: "緯度は-90から90の間で入力してください" }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, message: "経度は-180から180の間で入力してください" }

  # 半角数字のみを許可（距離）
  validates :radius, numericality: { only_integer: true, greater_than: 0, message: "距離は1以上の整数で入力してください" }
end
