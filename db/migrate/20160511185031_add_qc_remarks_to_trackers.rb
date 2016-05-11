class AddQcRemarksToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :qc_remarks, :string
    add_column :trackers, :prod_remarks, :string
  end
end
