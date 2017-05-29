class PageController < ApplicationController
  protect_from_forgery with: :exception
  # hello this is an incredibly basic scraper for bandcamp and youtube
  # since the website it is being used for basically serves no information
  # apart from the links/embeds themselves and images, there isn't really a need for a complex
  # structure

  # eventually these will just be all sidquik jobs which refresh once a day

  def index
    if !/(scrape)/.match(request.url).nil?
      # obviously temporary 
      commence_scraping
    elsif !/(releases.json)/.match(request.url).nil?
      get_releases
    elsif !/(videos.json)/.match(request.url).nil?
      get_youtube
    elsif !/(merch.json)/.match(request.url).nil?
      get_merch
    elsif !/(youtube_api_fetch)/.match(request.url).nil?
      youtube_api_fetch
    end
  end

  def get_merch
    render json: Merch.all
  end

  def get_releases
    render json: Release.all
  end

  def get_videos
    render json: Video.all
  end

  def commence_scraping
    bandcamp_scraper
    youtube_api_fetch
  end

  def bandcamp_scraper
    # bandcamp is nice and seemingly embeds the json containing all the information needed for the scrape within
    # an attribute of an element...there are two other pieces of information that are only available on the release
    # page itself however

    request = Nokogiri::HTML((open("https://#{Settings.bandcamp_page}.bandcamp.com/")))
    releases = JSON.parse((request.css(".music-grid"))[0].attributes["data-initial-values"].value)

    releases.each do |release|

      if !File.exist?("#{Rails.root}/public/#{release["id"]}.jpg")
        IO.copy_stream(open("https://f4.bcbits.com/img/a#{release["art_id"]}_16.jpg"), "#{Rails.root}/public/#{release["id"]}.jpg")
      end

      release_request = Nokogiri::HTML((open("https://#{Settings.bandcamp_page}.bandcamp.com/#{release["page_url"]}/")))
      release_request_info = release_request.css("div.tralbumData")[0].try(:children).try(:text)
      release_number = (/PLZ\d+/).match(release_request_info).nil? ? "" : (/PLZ\d+/).match(release_request_info)[0]
      release_request_medium = release_request.css("div.merchtype.secondaryText")[0].try(:children).try(:text)
      Release.create(
        name: release["title"],
        artist: release["artist"],
        url: release["page_url"],
        embed: Settings.embed_code.gsub("album=", "album=#{release["id"]}").html_safe,
        release_id: release["id"],
        release_medium: release_request_medium,
        release_number: release_number
      )

      Settings.embed_code.gsub("album=#{release["id"]}", "album=")
    end

    request_merch = Nokogiri::HTML((open("https://#{Settings.bandcamp_page}.bandcamp.com/merch")))
    merchandise = JSON.parse((request_merch.css(".merch-grid"))[0].attributes["data-initial-values"].value)
    merchandise.each do |merch|

      Merch.create(
        name: merch["title"],
        price: merch["price"],
        sold_out: merch["quantity_available"].to_i != 0
      )
      if !File.exist?("#{Rails.root}/public/#{merch["id"]}.jpg")
        IO.copy_stream(open("https://f4.bcbits.com/img/000#{merch["arts"][0]["image_id"]}_10.jpg"), "#{Rails.root}/public/#{merch["id"]}.jpg")
      end
    end

    if !File.exist?("#{Rails.root}/public/logo.jpg")
        IO.copy_stream(open(request.css("a.popupImage")[0].attributes["href"].text), "#{Rails.root}/public/logo.jpg")
    end
  end

  def youtube_api_fetch
    channel = Yt::Channel.new id: 'UCsU0dihadDYCeXXIqUMEr3Q'
    channel.videos.each do |video|
      Video.create(
        embed_url: video.embed_html
      )
    end
  end
end
