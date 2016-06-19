class AddTimeTakenToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :time_taken, :float
  end
end
