require 'cinch'
require 'ostruct'
require 'yaml'
require 'rmeetup'
require 'pry'

PREFIX = /^\./
SETTINGS = OpenStruct.new(YAML.load_file(File.expand_path('./turbot.yaml'))[:settings])
MEETUP_API_KEY = ENV['MEETUP_API_KEY']

#####################################################
# Setup plugins
#####################################################
dir = File.dirname(File.expand_path(__FILE__))
Dir.chdir dir
$: << "#{dir}/plugin"
Dir.chdir('plugin') {Dir.glob '*.rb', &method(:require)}
#####################################################

bot = Cinch::Bot.new do
  configure do |c|
    c.server          = SETTINGS.server
    c.channels        = [SETTINGS.channel]
    c.nick            = SETTINGS.nick
    c.plugins.plugins = TurbotPlugins.constants.map(&TurbotPlugins.method(:const_get))
  end
end

bot.start
