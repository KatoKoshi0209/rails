class AddShiftDetailsToAbsences < ActiveRecord::Migration[6.1]
  def change
    add_column :absences, :shift_date, :date
    add_column :absences, :shift_start_time, :time
    add_column :absences, :shift_end_time, :time
  end
end
