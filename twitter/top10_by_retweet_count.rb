require 'mongo'
require 'json'
require 'httpclient'

tweets = Mongo::Connection.new['twitter']['tweets']

screen_name = 'MongoDB'

tweets.find({'user.screen_name' => screen_name}, :sort => { retweet_count: -1 }, :limit => 10).each do |doc|
  puts doc.values_at('retweet_count', 'text').join("\t")
end





