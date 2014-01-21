class WebStats < Sequel::Model

  # I already want to refactor this to avoid so many SQL calls (slooooow)


  def self.top_urls(days, *qty) # quantity is optional
    return false unless (days >=  0)
    results = WebStats.
      where(:created_at => (Date.today - (days + 1))..(Date.today - days)). 
      
      # Ideally, we'd stick with convention, use "count" instead of "visits" and run a group_and_count()
      select_group(:url).
      select_append{count(:url).as(:visits)}. # Count URL "hits" and label meta-column
      order_by(Sequel.desc(:visits))

    # Quantity is optional but SQL doesn't like NULL values on LIMIT
    results.limit(qty) unless !qty 
    return results
  end

  def self.top_referrers(url, days, *qty)
    return false unless (days >= 0) or !url
    results = WebStats.
      where(:url => url, :created_at => ((Date.today - (days + 1))..(Date.today - days))).
      select_group(:referrer___url).
      select_append{count(:url).as(:visits)}. # Count URL "hits" and label meta-column
      order_by(Sequel.desc(:visits))

    # Quantity is optional but SQL doesn't like NULL values on LIMIT
    results.limit(qty) unless !qty 

    return results
  end
end
