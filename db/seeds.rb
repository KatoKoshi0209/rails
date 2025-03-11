User.create!(name: "admin",
            email: "admin@example.com",
            password: "password",
            password_confirmation: "password",
            administrator: true)

User.create!(name: "加藤航詩",
            email: "doradorayuji@gmail.com",
            password: "k89310141",
            password_confirmation: "k89310141",
            administrator: false)

# user_id 3-10のデータ
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

# user_id 3-10のデータ作成
users_data.each do |user|
  User.create!(name: user[:name],
              email: user[:email],
              password: user[:password],
              password_confirmation: user[:password],
              administrator: user[:administrator])
end

require 'date'

users = (2..10).to_a
start_date = Date.today - 120  # 120日前から（約4か月分）

attendances = []

(0..119).each do |i|
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
