require 'open-uri'
require 'json'

module TurbotPlugins
  class GemSearch
    include Cinch::Plugin
    set :prefix, PREFIX

    match /help/, method: :help
    def help(m)
      m.reply ".gem = Gem Search"
    end

    match /gem (\S+)/, method: :gemsearch
    def gemsearch(m, query)
      response = JSON(open 'http://rubygems.org/api/v1/search.json?query=%s' % query, &:read)
      m.reply pretty_response(response)
    rescue
      m.reply "Something exploded"
    end

    def pretty_response(response)
      "#{response.size} results: #{response.map{|r|r['name']}.join(', ')}"
    end
  end
end
