class AddUseLocationCheckToLocationSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :location_settings, :use_location_check, :boolean
  end
end
