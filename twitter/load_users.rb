require 'mongo'
require 'httpclient'
require 'json'

screen_name = ARGV[0] || 'garymurakami'
friends_ids_uri = "https://api.twitter.com/1/friends/ids.json?cursor=-1&screen_name=#{screen_name}"
friend_ids = JSON.parse(HTTPClient.get(friends_ids_uri).body)['ids']

connection = Mongo::Connection.new
db = connection['twitter']
collection = db['users']

friend_ids.each_slice(100) do |ids|
  users_lookup_uri = "https://api.twitter.com/1/users/lookup.json?user_id=#{ids.join(',')}"
  response = HTTPClient.get(users_lookup_uri)

  docs = JSON.parse(response.body) # high-level objects
  docs.each{|doc| doc['_id'] = doc['id']} # user supplied _id
  collection.insert(docs, :safe => true) # bulk insert
end
puts "users:#{collection.count}"
