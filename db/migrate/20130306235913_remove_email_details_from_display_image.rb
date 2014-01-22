class RemoveEmailDetailsFromDisplayImage < ActiveRecord::Migration
  def up

  end

  def down
    add_column :installations, :email, :string
    add_column :installations, :subject, :string
    add_column :installations, :external_message_id, :string
  end
end
