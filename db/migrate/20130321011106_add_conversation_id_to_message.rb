class AddConversationIdToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :conversation_id, :integer
    remove_column :messages, :picture_frame_id
    remove_column :messages, :picture_frame_type
  end
end
