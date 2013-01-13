# Author: Robert Jackson (robert.w.jackson@me.com)
# Inspired by epitron/pookie: https://github.com/epitron/pookie/blob/master/handlers/url_handler.rb

require 'uri'
require 'open-uri'
require 'mechanize'

require_relative 'url_handler/common'
require_relative 'url_handler/github_repo_handler'
require_relative 'url_handler/gist_handler'
require_relative 'url_handler/twitter_user_handler'
require_relative 'url_handler/twitter_status_handler'
require_relative 'url_handler/youtube_handler'
require_relative 'url_handler/image_handler'
require_relative 'url_handler/generic_handler'

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
      [GithubRepoHandler, GistHandler, TwitterUserHandler,
       TwitterStatusHandler, YoutubeHandler, ImageHandler, GenericHandler].each do |klass|
        return klass.new(url).info if klass.match?(url)
      end
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
  end
end
