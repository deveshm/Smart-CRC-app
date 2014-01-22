class CreateDisplayImagesAgain < ActiveRecord::Migration
  def change
    create_table :display_images do |t|
      t.integer :installation_id
      t.attachment :photo
      t.timestamps
    end
  end
end
