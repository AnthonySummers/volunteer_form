class ChangeShiftsToJsonbInVolunteers < ActiveRecord::Migration[7.0]
  def change
    change_column :volunteers, :shifts, :jsonb, default: []
  end
end
