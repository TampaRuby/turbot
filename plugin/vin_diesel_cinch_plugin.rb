require 'cgi'
require 'json'
require 'open-uri'

module TurbotPlugins
  class VinDiesel
    include Cinch::Plugin
    set :prefix, PREFIX

    PluginHandler.add_plugin(self)

    def self.help
      PluginCommand.new("'.vin diesel', '.vin says', '.vin'", "Rockin' Diesel Quote")
    end

    match /vin diesel$/i, method: :vin_diesel
    match /vin says$/i, method: :vin_diesel
    match /vin$/i, method: :vin_diesel
    def vin_diesel(m)
      m.reply quote
    end

    def quote
      json_data = open('http://api.icndb.com/jokes/random?firstName=Vin&lastName=Diesel').read
      CGI.unescapeHTML(JSON.parse(json_data)['value']['joke'])
    end
  end
end

