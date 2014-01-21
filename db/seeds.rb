# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'digest/md5'
require 'ruby-progressbar'

# Number of rows to generate
rows = 1000000 # ONEEMILLLIIOOONNNNN
# I see you're going for the big million, aye? You might wanna go
# grab a cup of coffee or read a book... or an entire series.



# I imagine additional URLs could've been added for "realism"
# but that felt a bit out of the scope of this specific exercise

# Array of URLs to be included in sample data
urls =  [
    "http://apple.com",
    "https://apple.com",
    "https://www.apple.com",
    "http://developer.apple.com",
    "http://en.wikipedia.org",
    "http://opensource.org"
    ]


# Array of referrers to be included in sample data
referrers =  [
    "http://apple.com",
    "https://apple.com",
    "https://www.apple.com",
    "http://developer.apple.com",
    nil
    ]


# Simple method, but highly readable, to generate the hash
def hash_me(id, url, ref, date)

  # Formatting date for hash as requested, e.g. 2012-01-01
  datef = Date.parse(date.to_s).strftime("%Y-%m-%d")

  if ref.nil?
    Digest::MD5.hexdigest({id: id, url: url, created_at: Time.parse(datef)}.to_s)
    # puts "#{id}, #{url}, #{datef}" # For debugging purposes
  else
    Digest::MD5.hexdigest({id: id, url: url, referrer: ref, created_at: Time.parse(datef)}.to_s)
    # puts "#{id}, #{url}, #{ref}, #{datef}" # For debugging purposes
  end
end


# Gives us a progress bar to help figure out the progress of this task
pbar = ProgressBar.create(:total => rows)


DB = Sequel::Model.db # initializes the DB constant with the environment settings


DB.transaction do # Using a transaction is marginally faster but may be significant over larger datasets
  rows.times do
    url           = urls.sample
    referrer      = referrers.sample
    random_date   = rand(10.days.ago..Time.now) # though docs showed iso8601, MySQL doesn't like that... :\ 

    # Let's create the new entry with the info we have
    ws = WebStats.insert(
      # ID is automagically generated
      :url => url,
      :referrer => referrer,
      :created_at => random_date
    )

    # Use the returned ID to generate the hash (and insert it)
    WebStats.where(:id => ws).update(
      :hash => hash_me(ws, url, referrer, random_date)
    )

    pbar.increment # ProgressBar stuff :)
  end
end
