class AddLimitsToTables < ActiveRecord::Migration
  def change
  	change_column :alerts,         :note    ,:string, :limit => 1000
  	change_column :events,         :note    ,:string, :limit => 1000
  	change_column :display_images, :caption, :string, :limit => 255
  end
end

