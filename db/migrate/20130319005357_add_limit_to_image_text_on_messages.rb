class AddLimitToImageTextOnMessages < ActiveRecord::Migration
  def change
  	  	change_column :messages, :image_text ,:string, :limit => 1000
  end
end
