class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :alert_type
      t.integer :installation_id

      t.timestamps
    end
  end
end
