class AddPhotoRefreshesPerDayToInstallations < ActiveRecord::Migration
  def change
    add_column :installations, :photo_refreshes_per_day, :integer
  end
end
