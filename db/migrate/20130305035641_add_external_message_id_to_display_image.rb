class AddExternalMessageIdToDisplayImage < ActiveRecord::Migration
  def change
    add_column :display_images, :external_message_id, :string
  end
end
