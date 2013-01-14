module TurbotPlugins::UrlHandler
  class ImageHandler
    include Common

    REGEXP = %r{(\.png|\.tif|\.jpg|\.gif)}

    attr_accessor :url

    def self.match?(string)
      REGEXP.match(string)
    end

    def initialize(url)
      self.url = url
    end

    def image
      @image ||= agent.head(url)
    end

    def mimetype
      image.response['content-type']
    end

    def size
      image.response['content-length']
    end

    def info
      "image: \2#{mimetype}\2 (#{size.to_i / 1024} KiB)"
    end
  end
end
