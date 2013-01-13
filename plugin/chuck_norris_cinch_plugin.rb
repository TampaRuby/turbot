require 'json'
require 'open-uri'

module TurbotPlugins
  class ChuckNorris
    include Cinch::Plugin
    set :prefix, PREFIX

    match /help/, method: :help
    def help(m)
      m.reply ".chuck norris = Rockin' Norris Quote"
      m.reply ".chuck says = Rockin' Norris Quote"
      m.reply ".chuck = Rockin' Norris Quote"
    end

    match /chuck norris$/, method: :chuck_norris
    match /chuck says$/, method: :chuck_norris
    def chuck_norris(m)
      m.reply quote
    end

    def quote
      json_data = open('http://api.icndb.com/jokes/random').read
      JSON.parse(json_data)['value']['joke']
    end
  end
end

