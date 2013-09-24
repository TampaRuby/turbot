module UrlHandler
  class GithubCommitHandler
    include Common

    REGEXP = %r{https?://(?:www\.)?github\.com/([^/]+?)/([^/]+)/commit/(\w+)}

    attr_accessor :url, :username, :repository, :sha

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

    def sha
      @sha ||= REGEXP.match(url)[3]
    end

    def api_url
      @api_url ||= "https://api.github.com/repos/#{username}/#{repository}/git/commits/#{sha}"
    end

    def api_data
      @api_data ||= get_json_data(api_url)
    end

    def message
      api_data['message'].split("\n\n").first
    end

    def author
      api_data['author']['name']
    end

    def info
      "github commit: \2#{username}/#{repository}\2 \2#{sha[0,7]}\2 - #{message}"
    end
  end
end


