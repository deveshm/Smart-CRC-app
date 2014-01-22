class RenameCaptionToImageText < ActiveRecord::Migration
  def change
    rename_column :display_images, :caption, :image_text
  end
end
