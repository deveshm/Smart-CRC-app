class RenameChannelIdToRespondsVia < ActiveRecord::Migration
  def change
    rename_column :channels, :channel_id, :responds_via
  end
end
