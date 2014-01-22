class RenameChannelToContact < ActiveRecord::Migration
    def change
        rename_table :channels, :contacts
    end 
end
