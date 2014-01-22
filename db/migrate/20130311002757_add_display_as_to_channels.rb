class AddDisplayAsToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :display_as, :string
  end
end
