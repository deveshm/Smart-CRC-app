class RenameNotificationToInstallation < ActiveRecord::Migration
     def change
        rename_table :notifications, :installations
    end 
end
