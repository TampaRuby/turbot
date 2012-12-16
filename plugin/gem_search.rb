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
      m.reply (!response.is_a?(Array) || response.empty?) ?
        'No results'                            :
        "#{response.size} results: #{response.map{|r|r['name']}.join(', ')}"
    rescue
      m.reply "Something exploded"
    end
  end
end
