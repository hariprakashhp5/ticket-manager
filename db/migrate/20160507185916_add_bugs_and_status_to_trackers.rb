class AddBugsAndStatusToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :bugs, :integer
    add_column :trackers, :status, :string
  end
end
