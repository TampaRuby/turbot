# Author: Robert Jackson (robert.w.jackson@me.com)
# Inspired by epitron/pookie: https://github.com/epitron/pookie/blob/master/handlers/url_handler.rb

require 'uri'
require 'open-uri'
require 'mechanize'

require_relative 'url_handler/common'
require_relative 'url_handler/github_repo_handler'
require_relative 'url_handler/gist_handler'

module TurbotPlugins::UrlHandler
  class Processor
    include Cinch::Plugin

    listen_to :channel

    def listen(m)
      URI.extract(m.raw, ['http','https']).each do |url|
        link_info = print_link_info(url)
        m.reply link_info
      end
    end

    private

    def print_link_info(url)
      [GithubRepoHandler, GistHandler].each do |klass|
        return klass.new(url).info if klass.match?(url)
      end

      case url
      when twitter_status_regexp
        twitter_status_info(url)
      when twitter_user_regexp
        twitter_user_info(url)
      when youtube_regexp
        youtube_info(url)
      when image_regexp
        image_info(url)
      else
        "title: \2#{get_title(url)}\2"
      end
    end

    def twitter_status_regexp
      %r{https?://twitter\.com/(?:#!/)?(.+/status/\d+)}
    end

    def twitter_status_info(url)
      url = cleanup_twitter_hashbang_url(url)
      page = agent.get(url)

      tweet   = clean_text(page.at(".tweet-text"))
      tweeter = page.at(".permalink-tweet .username").text

      "tweet: <\2#{tweeter}\2> #{tweet}"
    end

    def twitter_user_regexp
      %r{(https?://twitter\.com/)(?:#!/)?([^/]+)/?$}
    end

    def twitter_user_info(url)
      url = cleanup_twitter_hashbang_url(url)
      page = agent.get(url)

      username  = twitter_user_regexp.match(url)[2]
      fullname  = page.at(".user-actions")["data-name"]

      tweets    = clean_text(page.at("ul.stats li a[data-element-term='tweet_stats'] strong"))
      followers = clean_text(page.at("ul.stats li a[data-element-term='follower_stats'] strong"))
      following = clean_text(page.at("ul.stats li a[data-element-term='following_stats'] strong"))

      "tweeter: \2@#{username}\2 (\2#{fullname}\2) | tweets: \2#{tweets}\2, following: \2#{following}\2, followers: \2#{followers}\2"
    end

    def cleanup_twitter_hashbang_url(url)
      if url =~ %r{#!/(.+)}
        url = 'https://twitter.com/' + $1
      end

      url
    end

    def image_regexp
      %r{(\.png|\.tif|\.jpg|\.gif)}
    end

    def image_info(url)
      image = agent.head(url)

      mimetype, size = image.response.values_at('content-type', 'content-length')

      "image: \2#{mimetype}\2 (#{size.to_i / 1024} KiB)"
    end

    def get_title(url)
      page = agent.get(url)

      cleanup_title(page.search("title").first)
    end

    def cleanup_title(title)
      clean_text(title)[0..255]
    end

    def agent
      @agent ||= Mechanize.new
    end

    def clean_text(element)
      if element.respond_to?(:inner_text)
        CGI.unescapeHTML(element.inner_text.strip.gsub(/\s*\n+\s*/, " "))
      else
        element.to_s
      end
    end

    def youtube_regexp
       %r{https?://(www\.)?youtube\.com/watch\?}
    end

    def youtube_info(url)
      video_id = url.match(/\?v\=(\w+)$/)[1]
      page     = agent.get("http://gdata.youtube.com/feeds/api/videos/#{video_id}?v=1&alt=json")
      json     = JSON.parse(page.body)

      views    = json['entry']["yt$statistics"]["viewCount"].to_i
      date     = DateTime.parse json['entry']["published"]["$t"]
      time     = json['entry']["media$group"]["yt$duration"]["seconds"].to_i
      title    = json['entry']["media$group"]["media$title"]["$t"]
      rating   = json['entry']["gd$rating"]["average"] ? "%0.1f" % json['entry']["gd$rating"]["average"] : "?"

      "video: \2#{title}\2 (length: \2#{time}\2, views: \2#{views}\2, rating: \2#{rating}\2, posted: \2#{date}\2)"
    end
  end
end
