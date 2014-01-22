class AddIndexToInstallationsContactId < ActiveRecord::Migration
  def change
  	add_index :installations, :contact_id, unique: true
  end
end
