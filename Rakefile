require 'mongo'

database_name = 'twitter'

namespace :twitter do
  desc 'drop_database'
  task :drop_database do
    Mongo::Connection.new.drop_database(database_name)
  end
  desc 'load users'
  task :load_users do
    sh "ruby twitter/load_users.rb"
  end
  desc 'top 10 users by followers count'
  task :top10_by_followers_count do
    sh "ruby twitter/top10_by_followers_count.rb"
  end
  desc 'load tweets'
  task :load_tweets do
    sh "ruby twitter/load_tweets.rb"
  end
  desc 'top 10 tweets by retweet_count'
  task :top10_by_retweet_count do
    sh "ruby twitter/top10_by_retweet_count.rb"
  end
end