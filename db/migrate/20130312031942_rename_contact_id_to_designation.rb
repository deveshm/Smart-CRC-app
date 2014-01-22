class RenameContactIdToDesignation < ActiveRecord::Migration
  def change
    rename_column :installations, :contact_id, :designation
  end
end
