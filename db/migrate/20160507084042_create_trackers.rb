class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string :ticket_id
      t.string :integer
      t.string :created
      t.string :eta
      t.string :finished
      t.string :tow
      t.string :owner
      t.integer :noc
      t.string :staging
      t.string :comp
      t.string :disc

      t.timestamps null: false
    end
  end
end
