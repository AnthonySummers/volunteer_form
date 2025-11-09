class ChangeShiftsToJsonInVolunteers < ActiveRecord::Migration[7.0]
  def change
    remove_column :volunteers, :shifts, :text
    add_column :volunteers, :shifts, :json, default: []
  end
end
