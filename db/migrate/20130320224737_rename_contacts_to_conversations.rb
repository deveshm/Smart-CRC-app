class RenameContactsToConversations < ActiveRecord::Migration
    def change
        rename_table :contacts, :conversations
    end 
end
