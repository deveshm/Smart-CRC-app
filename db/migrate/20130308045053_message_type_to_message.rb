class MessageTypeToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :message_type, :string
  end
end
