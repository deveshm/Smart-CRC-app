class AddNextInvestigationTimeToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :next_investigation_time, :datetime
  end
end
