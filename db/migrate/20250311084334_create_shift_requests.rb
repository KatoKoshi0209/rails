class CreateShiftRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :shift_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
