class RenameChannelIdToContactId < ActiveRecord::Migration
  def change
    rename_column :messages, :channel_id, :contact_id
  end
end
