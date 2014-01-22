class AddCaptionToDisplayImage < ActiveRecord::Migration
  def change
    add_column :display_images, :caption, :string
  end
end
