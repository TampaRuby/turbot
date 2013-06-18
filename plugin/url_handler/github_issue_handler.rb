module UrlHandler
  class GithubIssueHandler
    include Common

    REGEXP = %r{https?://(?:www\.)?github\.com/([^/]+?)/([^/]+)/issues/(\d+)}

    attr_accessor :url, :username, :repository, :issue_number

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

    def issue_number
      @issue_number ||= REGEXP.match(url)[3]
    end

    def api_url
      @api_url ||= "https://api.github.com/repos/#{username}/#{repository}/issues/#{issue_number}"
    end

    def api_data
      @api_data ||= get_json_data(api_url)
    end

    def comments
      api_data['comments']
    end

    def title
      api_data['title']
    end

    def info
      "github issue: \2#{username}/#{repository}\2 \2##{issue_number}\2 - #{title}"
    end
  end
end

