require 'uri'
require 'cgi'
require 'json'
require 'open-uri'
require 'mechanize'

module TurbotPlugins::UrlHandler
  module Handlers
    def self.handlers
      @handlers
    end

    def self.add_handler(handler)
      @handlers ||= []
      @handlers << handler
    end
  end

  module Common
    def self.included(base)
      Handlers.add_handler(base)
    end

    private

    def agent
      @agent ||= Mechanize.new
    end

    def get_json_data(url)
      page = agent.get(url)
      JSON.parse(page.body)
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
