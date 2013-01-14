require 'open-uri'
require 'json'

module TurbotPlugins
  class GemSearch
    include Cinch::Plugin
    set :prefix, PREFIX

    match /help/, method: :help
    def help(m)
      m.reply ".gem \x02Search Term\x02 = Gem Search"
      m.reply ".gem info \x02Gem Name\x02 = Gem Info"
    end

    match /gem info (\S+)/, method: :gem_info
    def gem_info(m, gem)
      data = get_json_data("https://rubygems.org/api/v1/gems/#{gem}.json")
      m.reply "gem: \x02#{data['name']}\x02 desc: \x02#{data['info'][0..140]}\x02 ver: \x02#{data['version']}\x02 url: \x02#{data['homepage_uri']}\x02"
    end

    match /gem (\S+)$/, method: :gemsearch
    def gemsearch(m, query)
      response = get_json_data('http://rubygems.org/api/v1/search.json?query=' + query)
      m.reply pretty_response(response)
    end

    def pretty_response(response)
      "gems: #{response.map{|r|r['name']}.join(', ')}"
    end

    def get_json_data(url)
      data = open(url).read
      JSON(data)
    end
  end
end
