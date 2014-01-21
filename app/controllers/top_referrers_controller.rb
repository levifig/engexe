class TopReferrersController < ApplicationController
  def index
    urls_top = 10
    referrers_top = 5
    days = 4 # + 1 in days - this variable could eventually be passed via URL request
    urls = Hash.new
    referrers = Array.new

    (0..days).each do |day|
      top_urls = WebStats.top_urls(days, urls_top)
      top_urls.each do |top_url|
        referrers.push({
          :url => top_url[:url], 
          :visits => top_url[:visits],
          :referrers => WebStats.top_referrers(top_url.url, days, referrers_top)
          })
      end
      urls[(Date.today - day).to_s] = referrers
    end

    render :json => urls
  end
end
