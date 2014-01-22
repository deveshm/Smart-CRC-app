class AddInstallationIdToDisplayImage < ActiveRecord::Migration
  def change
    add_column :display_images, :installation_id, :integer
  end
end
