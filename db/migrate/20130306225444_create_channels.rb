class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :external_message_id
      t.text :message_prefix
      t.text :channel_id
      t.integer :installation_id

      t.timestamps
    end
  end
end
