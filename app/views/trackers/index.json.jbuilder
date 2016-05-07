json.array!(@trackers) do |tracker|
  json.extract! tracker, :id, :ticket_id, :created, :eta, :finished, :owner, :noc, :disc
  json.url tracker_url(tracker, format: :json)
end
