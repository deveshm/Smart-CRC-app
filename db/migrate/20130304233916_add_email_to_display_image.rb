class AddEmailToDisplayImage < ActiveRecord::Migration
  def change
    add_column :display_images, :email, :string
    add_column :display_images, :subject, :string
  end
end
