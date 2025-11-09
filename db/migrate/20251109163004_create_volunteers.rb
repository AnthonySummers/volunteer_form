class CreateVolunteers < ActiveRecord::Migration[7.2]
  def change
    create_table :volunteers do |t|
      t.string :name
      t.string :nickname
      t.string :email
      t.string :phone
      t.string :city
      t.date :date
      t.text :shifts
      t.string :training
      t.boolean :waiver

      t.timestamps
    end
  end
end
