class AddNoteToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :note, :string
  end
end
