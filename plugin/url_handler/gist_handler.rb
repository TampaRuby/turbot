module TurbotPlugins::UrlHandler
  class GistHandler
    include Common

    REGEXP = %r{https?://gist\.github\.com/(\w+)$}

    attr_accessor :url

    def self.match?(string)
      REGEXP.match(string)
    end

    def initialize(url)
      self.url = url
    end

    def gist_number
      @gist_number ||= REGEXP.match(url)[1]
    end

    def api_url
      @api_url ||= 'https://api.github.com/gists/' + gist_number
    end

    def api_data
      @api_data ||= get_json_data(api_url)
    end

    def description
      api_data['description']
    end

    def user
      api_data['user']
    end

    def forks
      api_data['forks']
    end

    def info
      "gist: \2#{user['login']}\2 forks: \2#{forks.length}\2 desc:\2#{(description[0..140])}\2"
    end
  end
end
