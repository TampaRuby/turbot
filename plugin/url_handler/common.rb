require 'cgi'
require 'json'

module TurbotPlugins::UrlHandler
  module Common
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
