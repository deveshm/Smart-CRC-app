class AddDeviceIdToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :device_id, :string
  end
end
