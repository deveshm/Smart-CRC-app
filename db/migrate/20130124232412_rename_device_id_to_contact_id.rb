class RenameDeviceIdToContactId < ActiveRecord::Migration
  def change
    rename_column :installations, :device_id, :contact_id
  end
end
