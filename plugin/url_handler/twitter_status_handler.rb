module TurbotPlugins::UrlHandler
  class TwitterStatusHandler
    include Common

    REGEXP = %r{https?://twitter\.com/(?:#!/)?(.+/status/\d+)}

    attr_accessor :url

    def self.match?(string)
      REGEXP.match(string)
    end

    def initialize(url)
      self.url = 'https://twitter.com/' + REGEXP.match(url)[1]
    end

    def page
      agent.get(url)
    end

    def tweet
      clean_text(page.at(".tweet-text"))
    end

    def tweeter
      clean_text(page.at(".permalink-tweet .username").text)
    end

    def info
      "tweet: <\2#{tweeter}\2> #{tweet}"
    end
  end
end
