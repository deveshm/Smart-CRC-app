class AddInterruptDurationToInstallation < ActiveRecord::Migration
  def change
    add_column :installations, :interrupt_duration, :integer
    remove_column :messages, :interrupt_duration
  end
end
