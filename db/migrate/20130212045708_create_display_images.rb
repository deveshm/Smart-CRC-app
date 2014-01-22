class CreateDisplayImages < ActiveRecord::Migration
  def change
    create_table :display_images do |t|
      t.binary :binary_data
      t.string :content_type
      t.integer :image_size

      t.timestamps
    end
  end
end
