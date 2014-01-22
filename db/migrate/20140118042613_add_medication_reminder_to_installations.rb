class AddMedicationReminderToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :medication_reminder, :integer
  end
end
