class RenameNotificationToEvent < ActiveRecord::Migration
     def change
        rename_table :notifications, :events
    end 
end
