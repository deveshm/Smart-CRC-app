class CreateUsageEvents < ActiveRecord::Migration
  def change
    create_table :usage_events do |t|
      t.datetime :time
      t.string :usage_event_type
      t.integer :installation_id

      t.timestamps
    end
  end
end
