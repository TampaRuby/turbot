module UrlHandler
  class YoutubeHandler
    include Common

    REGEXP = %r{https?://(?:www\.)?youtube\.com/watch\?v\=(\w+)$}

    attr_accessor :url, :video_id

    def self.match?(string)
      REGEXP.match(string)
    end

    def initialize(url)
      self.video_id = REGEXP.match(url)[1]
      self.url      = "http://gdata.youtube.com/feeds/api/videos/#{video_id}?v=1&alt=json"
    end

    def api_data
      @api_data ||= get_json_data(url)['entry']
    end

    def views
      api_data["yt$statistics"]["viewCount"].to_i
    end

    def date
      DateTime.parse api_data["published"]["$t"]
    end

    def length
      api_data["media$group"]["yt$duration"]["seconds"].to_i
    end

    def title
      api_data["media$group"]["media$title"]["$t"]
    end

    def average_rating
      api_data["gd$rating"]["average"]
    end

    def rating
      average_rating ? "%0.1f" % average_rating : '?'
    end

    def info
      "video: \2#{title}\2 (length: \2#{length}\2, views: \2#{views}\2, rating: \2#{rating}\2, posted: \2#{date}\2)"
    end
  end
end
