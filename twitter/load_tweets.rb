require 'mongo'
require 'httpclient'
require 'json'

db = Mongo::Connection.new['twitter']
users = db['users']
tweets = db['tweets']
tweets.ensure_index('user.id') # dot notation to specify subfield

users.find({}, {fields: {id: true, screen_name: true, since_id: true}}).each do |user|
  print user['screen_name'] + ':'

  twitter_user_timeline_uri =  "https://api.twitter.com/1/statuses/user_timeline.json?user_id=#{user['id']}&count=200&include_rts=true&contributor_details=true"
  twitter_user_timeline_uri += "since_id=#{user['since_id']}" if user['since_id']
  response = HTTPClient.get(twitter_user_timeline_uri)

  docs = JSON.parse(response.body) # high-level objects

  if docs.class == Hash
    puts
    next if docs['error'] == 'Not authorized'
    raise response.body
  end

  if docs.size > 0
    docs.each{|doc| doc['_id'] = doc['id']} # user supplied _id
    tweets.insert(docs, :continue_on_error => true) # bulk insert
    users.update({_id: user['_id']}, {'$set' => {'since_id' => docs.last['id']}})
  end
  puts tweets.count(:query => {'user.id' => user['id']})
end
puts "tweets:#{tweets.count}"

