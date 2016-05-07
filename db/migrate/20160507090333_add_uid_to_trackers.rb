class AddUidToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :uid, :integer
  end
end
