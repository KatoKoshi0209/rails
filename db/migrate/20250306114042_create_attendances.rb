class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|
      t.datetime :attendance_time
      t.datetime :leave_time
      t.datetime :break_start_time
      t.datetime :break_end_time
      t.integer :user_id
      t.timestamps
    end
  end
end
