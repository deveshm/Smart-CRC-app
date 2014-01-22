class RenameNotificationTypeToEventType < ActiveRecord::Migration
  def change
    rename_column :events, :notification_type, :event_type
  end
end
