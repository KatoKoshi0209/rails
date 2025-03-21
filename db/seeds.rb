# ユーザー作成 (変更なし)
User.create!(name: "admin",
            email: "admin@example.com",
            password: "k89310141",
            password_confirmation: "k89310141",
            administrator: true)

User.create!(name: "加藤航詩",
            email: "doradorayuji@gmail.com",
            password: "k89310141",
            password_confirmation: "k89310141",
            administrator: false)

# user_id 3-10のデータ (変更なし)
users_data = [
  { name: "田中太郎", email: "tanaka@example.com", password: "password3", administrator: false },
  { name: "鈴木花子", email: "suzuki@example.com", password: "password4", administrator: false },
  { name: "佐藤次郎", email: "sato@example.com", password: "password5", administrator: false },
  { name: "高橋誠", email: "takahashi@example.com", password: "password6", administrator: false },
  { name: "山本一郎", email: "yamamoto@example.com", password: "password7", administrator: false },
  { name: "木村幸子", email: "kimura@example.com", password: "password8", administrator: false },
  { name: "伊藤健太", email: "ito@example.com", password: "password9", administrator: false },
  { name: "中村光", email: "nakamura@example.com", password: "password10", administrator: false }
]

users_data.each do |user|
  User.create!(name: user[:name],
              email: user[:email],
              password: user[:password],
              password_confirmation: user[:password],
              administrator: user[:administrator])
end

require 'date'

users = (2..10).to_a
start_date = Date.today - 180 

attendances = []

(0..179).each do |i|  # 6か月分のデータ
  date = start_date + i

  users.each do |user_id|
    attendance_time = Time.zone.parse("#{date} #{rand(7..9)}:00:00")  # 7:00~9:00の間でランダム
    leave_time = Time.zone.parse("#{date} #{rand(17..19)}:00:00")     # 17:00~19:00の間でランダム
    break_start_time = Time.zone.parse("#{date} #{rand(11..12)}:00:00")  # 11:00~12:00の間でランダム
    break_end_time = Time.zone.parse("#{date} #{rand(12..13)}:00:00")    # 12:00~13:00の間でランダム

    attendances << {
      attendance_time: attendance_time,
      leave_time: leave_time,
      break_start_time: break_start_time,
      break_end_time: break_end_time,
      user_id: user_id
    }
  end
end

Attendance.create!(attendances)

LocationSetting.create!(
  office_name: "お店",
  latitude: 34.723985,
  longitude: 135.492479,
  radius: 2010,
  use_location_check: true
)

shift_requests_data = []
users = User.where(administrator: false)

# 今月のシフト希望データ作成
(1..31).each do |i|  # 今月の日数分ループ
  date = Date.today.beginning_of_month + i - 1

  next if date.month != Date.today.month  # 今月の日付だけ

  selected_users = users.sample(3) # 同じ日に最大3人をランダムに選ぶ

  selected_users.each do |user|
    shift_requests_data << {
      user_id: user.id,
      date: date,
      start_time: Time.zone.parse("#{date} 09:00:00"),
      end_time: Time.zone.parse("#{date} 18:00:00")
    }
  end
end

# 来月のシフト希望データ作成
(1..31).each do |i|  # 来月の日数分ループ
  date = Date.today.next_month.beginning_of_month + i - 1

  next if date.month != Date.today.next_month.month  # 来月の日付だけ

  selected_users = users.sample(3) # 同じ日に最大3人をランダムに選ぶ

  selected_users.each do |user|
    shift_requests_data << {
      user_id: user.id,
      date: date,
      start_time: Time.zone.parse("#{date} 09:00:00"),
      end_time: Time.zone.parse("#{date} 18:00:00")
    }
  end
end

# シフト希望データを作成
ShiftRequest.create!(shift_requests_data)

# Shiftダミーデータ作成
shifts_data = []

shift_requests = ShiftRequest.all.group_by(&:date)

shift_requests.each do |date, shift_requests_for_date|
  shift_requests_for_date.first(2).each do |shift_request|
    shifts_data << {
      user_id: shift_request.user_id,
      date: shift_request.date,
      start_time: shift_request.start_time,
      end_time: shift_request.end_time,
    }
  end
end

# Shiftデータを作成
Shift.create!(shifts_data)