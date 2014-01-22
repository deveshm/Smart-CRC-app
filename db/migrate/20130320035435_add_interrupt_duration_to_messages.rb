class AddInterruptDurationToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :interrupt_duration, :integer
  end
end
