# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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

require 'date'

user_id = 2
start_date = Date.today - 90  # 90日前から

attendances = (0..89).map do |i|
  date = start_date + i
  {
    attendance_time: Time.zone.parse("#{date} 09:00:00"),
    leave_time: Time.zone.parse("#{date} 18:00:00"),
    break_start_time: Time.zone.parse("#{date} 12:00:00"),
    break_end_time: Time.zone.parse("#{date} 13:00:00"),
    user_id: user_id
  }
end

Attendance.create!(attendances)
            