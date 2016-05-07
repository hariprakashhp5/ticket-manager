class Tracker < ActiveRecord::Base

def self.to_csv(options = {})
	CSV.generate(options) do |csv|
		name_array={"Date"=>"created_at","TICKET ID"=>"ticket_id",
			"TICKET OWNER"=>"owner","CREATED"=>"created",
			"ETA"=>"eta","FINISHED"=>"finished","TYPE OF WORK"=>"tow",
			"COMMITS"=>"noc","STAGING"=>"staging",
			"DESCRIPTION"=>"disc","CONFIG OWNER"=>"uid"}
		csv << name_array.keys #column_names
		all.each do |ticket|
			csv << ticket.attributes.values_at(*name_array.values)
		end
	end
end
	
end
