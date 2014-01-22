class AddLimitToMessageContent < ActiveRecord::Migration
  def change
  	change_column :messages,         :content    ,:string, :limit => 1000
  end
end
