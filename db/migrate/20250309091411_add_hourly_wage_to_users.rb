class AddHourlyWageToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hourly_wage, :integer, null: false, default: 1200
  end
end
