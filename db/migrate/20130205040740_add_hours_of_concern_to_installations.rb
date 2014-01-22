class AddHoursOfConcernToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :start_hour_of_concern, :int
    add_column :installations, :end_hour_of_concern, :int
  end
end
