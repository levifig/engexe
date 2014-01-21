class TopUrlsController < ApplicationController
  def index
    days = 4 # + 1 for today
    urls = Hash.new

    (0..days).each do |day|
      urls[(Date.today - day).to_s] = WebStats.top_urls(day)
    end

    render :json => urls
  end
end
