class AddMoreMedicationRemindersToInstallations < ActiveRecord::Migration
  def change
  	add_column :installations, :medication_reminder_two, :integer
  	add_column :installations, :medication_reminder_three, :integer
  end
end
