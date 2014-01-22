class AddNoteToEvents < ActiveRecord::Migration
  def change
    add_column :events, :note, :string
  end
end
