class ScrapersController < ApplicationController
	require 'ScrapePlayerHistory'
  def launch
  	@scraper = Scraper.find(1) 
    @full_scrape = false
  end
  def start
  	logger.debug "inside start #{params.inspect}"
    if params[:full_scrape]
      full_scrape = params[:full_scrape]
    else
      full_scrape = false
    end
  	scrape_messages = ScrapePlayerHistory.new(full_scrape, Scraper.find(1)).start
    @scraper = Scraper.find(1)
    if scrape_messages
      flash.now[:notice] = "You have successfully scraped the player history"
    end      
    respond_to do |format| 
      format.js
    end
  end
end
