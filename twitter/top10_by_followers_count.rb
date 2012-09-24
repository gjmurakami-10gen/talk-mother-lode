require 'mongo'

users = Mongo::Connection.new['twitter']['users']

users.find({}, :sort => { followers_count: -1 }, :limit => 10).each do |doc|
  puts doc.values_at('followers_count', 'screen_name').join("\t")
end
