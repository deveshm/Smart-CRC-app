class RemoveOldFieldsFromDisplayImage < ActiveRecord::Migration
  def up
    remove_column :display_images, :email
    remove_column :display_images, :subject
    remove_column :display_images, :external_message_id
  end

  def down
    add_column :display_images, :email, :string
    add_column :display_images, :subject, :string
    add_column :display_images, :external_message_id, :string
  end
end
