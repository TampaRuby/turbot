module UrlHandler
  class GenericHandler
    include Common

    attr_accessor :url

    def self.match?(string)
      true
    end

    def initialize(url)
      self.url = url
    end

    def page
      @page ||= agent.get(url)
    end

    def title
      clean_text(page.search("title").first)[0..255]
    end

    def info
      "title: \2#{title}\2"
    end
  end
end
