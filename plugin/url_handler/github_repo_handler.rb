module TurbotPlugins::UrlHandler
  class GithubRepoHandler
    include Common

    REGEXP = %r{https?://(?:www\.)?github\.com/([^/]+?)/([^/]+)}

    attr_accessor :url, :username, :repository

    def self.match?(string)
      REGEXP.match(string)
    end

    def initialize(url)
      self.url = url
    end

    def username
      @username ||= REGEXP.match(url)[1]
    end

    def repository
      @repository ||= REGEXP.match(url)[2]
    end

    def api_url
      @api_url ||= "https://api.github.com/repos/#{username}/#{repository}"
    end

    def api_data
      @api_data ||= get_json_data(api_url)
    end

    def watchers
      api_data['watchers']
    end

    def forks
      api_data['forks']
    end

    def description
      api_data['description']
    end

    def info
      "github: \2#{username}/#{repository}\2 - #{description} (watchers: \2#{watchers}\2, forks: \2#{forks}\2)"
    end
  end
end
