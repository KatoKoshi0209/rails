class CreateLocationSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :location_settings do |t|
      t.string :office_name
      t.float :latitude
      t.float :longitude
      t.integer :radius

      t.timestamps
    end
  end
end
