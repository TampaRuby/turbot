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
Dir.chdir('plugin') {Dir.glob '*cinch_plugin.rb', &method(:require)}
#####################################################

bot = Cinch::Bot.new do
  configure do |c|
    c.server          = SETTINGS.server
    c.channels        = [SETTINGS.channel]
    c.nick            = SETTINGS.nick
    c.plugins.plugins = TurbotPlugins.constants.map(&TurbotPlugins.method(:const_get))
  end

  on :message, /^Open the pod bay doors/i do |m|
    m.reply "I'm sorry, Dave. I'm afraid I can't do that."
  end

  on :message, /turbot/i do |m|
    m.reply "Who me? (Type .help to see what I can do.)"
  end
end

bot.start
