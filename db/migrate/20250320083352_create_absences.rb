class CreateAbsences < ActiveRecord::Migration[6.1]
  def change
    create_table :absences do |t|
      t.integer :user_id, null: false
      t.integer :shift_id
      t.integer :status, default: 0, null: false #0 :未承認, 1: 承認, 2: 却下
      t.timestamps
    end
  end
end
