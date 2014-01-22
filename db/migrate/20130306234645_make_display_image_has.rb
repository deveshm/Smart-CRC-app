class MakeDisplayImageHas < ActiveRecord::Migration

  def change
    add_column :display_images, :picture_frame_id, :integer
    add_column :display_images, :picture_frame_type, :string
  end

end
