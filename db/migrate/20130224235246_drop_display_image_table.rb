class DropDisplayImageTable < ActiveRecord::Migration
  def up
    drop_table :display_images
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
