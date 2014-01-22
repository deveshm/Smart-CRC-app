class AddMessageTypeToDisplayImage < ActiveRecord::Migration
  def change
    add_column :display_images, :message_type, :string
  end
end
