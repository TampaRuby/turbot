require 'cinch'
require 'ostruct'
require 'yaml'
require 'pry'

PREFIX = /^\./
SETTINGS = OpenStruct.new(YAML.load_file(File.expand_path('./turbot.yaml'))[:settings])

module TurbotPlugins;end

require './plugin/gem_search.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = SETTINGS.server
    c.channels = [SETTINGS.channel]
    c.nick     = SETTINGS.nick
    c.plugins.plugins = [TurbotPlugins::GemSearch]
  end
end

bot.start
