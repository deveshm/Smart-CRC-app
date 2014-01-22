class AddInterruptToDisplayImage < ActiveRecord::Migration
  def change
    add_column :display_images, :interrupt, :boolean
  end
end
