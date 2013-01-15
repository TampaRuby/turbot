require 'cgi'
require 'json'
require 'open-uri'

module TurbotPlugins
  class ChuckNorris
    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.help
      PluginCommand.new("'.chuck norris', '.chuck says', '.chuck'", "Rockin' Norris Quote")
    end

    match /chuck norris$/i, method: :chuck_norris
    match /chuck says$/i, method: :chuck_norris
    match /chuck$/i, method: :chuck_norris
    def chuck_norris(m)
      m.reply quote
    end

    def quote
      json_data = open('http://api.icndb.com/jokes/random').read
      CGI.unescapeHTML(JSON.parse(json_data)['value']['joke'])
    end
  end
end

