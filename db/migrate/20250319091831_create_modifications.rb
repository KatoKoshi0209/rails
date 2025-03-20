class CreateModifications < ActiveRecord::Migration[6.1]
  def change
    create_table :modifications do |t|
      # 修正後のデータを格納
      t.datetime :modify_attendance_time, null: false
      t.datetime :modify_leave_time, null: false
      t.datetime :modify_break_start_time
      t.datetime :modify_break_end_time
      t.string  :modify_reason
      t.integer :user_id, null: false
      t.integer :attendance_id, null: false
      t.integer :status, default: 0, null: false #0 :未承認, 1: 承認, 2: 却下
      t.timestamps
    end
  end
end
