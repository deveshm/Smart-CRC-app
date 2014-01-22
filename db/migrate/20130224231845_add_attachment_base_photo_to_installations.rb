class AddAttachmentBasePhotoToInstallations < ActiveRecord::Migration
  def self.up
    change_table :installations do |t|
      t.attachment :base_photo
    end
  end

  def self.down
    drop_attached_file :installations, :base_photo
  end
end
