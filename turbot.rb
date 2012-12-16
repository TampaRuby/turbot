require 'cinch'
require 'ostruct'
require 'yaml'
require 'pry'

PREFIX = /^\./
SETTINGS = OpenStruct.new(YAML.load_file(File.expand_path('./turbot.yaml'))[:settings])
MEETUP_API_KEY = 'MEETUP_API_KEY'

module TurbotPlugins;end

require './plugin/gem_search.rb'
require './plugin/meetup.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = SETTINGS.server
    c.channels = [SETTINGS.channel]
    c.nick     = SETTINGS.nick
    c.plugins.plugins = [TurbotPlugins::GemSearch, TurbotPlugins::Meetup]
  end
end

bot.start
