class CreateNotifications1 < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
