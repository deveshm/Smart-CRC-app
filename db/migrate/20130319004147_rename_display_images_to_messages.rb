class RenameDisplayImagesToMessages < ActiveRecord::Migration
   def change
        rename_table :display_images, :messages
    end 
end
