require 'open-uri'
require 'json'

module TurbotPlugins
  class GemSearch
    include Cinch::Plugin
    set :prefix, PREFIX
    match /gem (\S+)/, method: :gemsearch
    GemUrl = 'http://rubygems.org/api/v1/search.json?query=%s'

    def gemsearch(m, query)
      response = JSON(open GemUrl % query, &:read)
      m.reply pretty_response(response)
    rescue
      m.reply "Something exploded"
    end

    def pretty_response(response)
      "#{response.size} results: #{response.map{|r|r['name']}.join(', ')}"
    end
  end
end
