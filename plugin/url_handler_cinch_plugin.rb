# Author: Robert Jackson (robert.w.jackson@me.com)
#     Inspired by epitron/pookie: https://github.com/epitron/pookie/blob/master/handlers/url_handler.rb

require 'uri'
require 'colored'
require 'open-uri'
require 'mechanize'

module TurbotPlugins
  class UrlHandler
    include Cinch::Plugin

    listen_to :channel

    def listen(m)
      URI.extract(m.raw, ['http','https']).each do |url|
        link_info = print_link_info(url)
        $stdout.puts link_info
        m.reply link_info
      end
    end

    private

    def print_link_info(url)
      page = agent.get(url)

      case url
      when github_regexp
        github_info(url, page)
      else
        "title: \2#{get_title(page)}\2"
      end
    end

    def github_regexp
      %r{https?://(?:www\.)?github\.com/([^/]+?)/([^/]+?)$}
    end

    def github_info(url, page)
      username, repository = url.scan(github_regexp).first

      watchers, forks = page.search("a.social-count").map{|e| clean_text(e)}

      desc     = page.at("#repository_description")
      desc.at("span").remove
      desc     = clean_text(desc)

      "github: \2#{username}/#{repository}\2 - #{desc} (watchers: \2#{watchers}\2, forks: \2#{forks}\2)"
    end

    def get_title(page)
      # Generic parser
      titles = page.search("title")
      if titles.any?
        title = clean_text(titles.first)
        title = title[0..255] if title.length > 255
        title
      else
        nil
      end
    end

    def agent
      @agent ||= Mechanize.new
    end

    def clean_text(element)
      if element.inner_text
        CGI.unescapeHTML(element.inner_text.strip.gsub(/\s*\n+\s*/, " "))
      else
        nil
      end
    end
  end
end
