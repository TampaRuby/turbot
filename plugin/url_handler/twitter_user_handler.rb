module TurbotPlugins::UrlHandler
  class TwitterUserHandler
    include Common

    REGEXP = %r{https?://twitter\.com/(?:#!/)?([^/]+)/?$}

    attr_accessor :url

    def self.match?(string)
      REGEXP.match(string)
    end

    def initialize(url)
      self.url = 'https://twitter.com/' + REGEXP.match(url)[1]
    end

    def page
      @page ||= agent.get(url)
    end

    def username
      @username ||= REGEXP.match(url)[1]
    end

    def fullname
      @fullname ||= page.at(".user-actions")["data-name"]
    end

    def tweets
      @tweets ||= clean_text(page.at("ul.stats li a[data-element-term='tweet_stats'] strong"))
    end

    def followers
      @followers ||= clean_text(page.at("ul.stats li a[data-element-term='follower_stats'] strong"))
    end

    def following
      @following ||= clean_text(page.at("ul.stats li a[data-element-term='following_stats'] strong"))
    end

    def info
      "tweeter: \2@#{username}\2 (\2#{fullname}\2) | tweets: \2#{tweets}\2, following: \2#{following}\2, followers: \2#{followers}\2"
    end
  end
end
