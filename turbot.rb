require 'bundler/setup'
Bundler.require(:default)

require 'ostruct'
require 'yaml'
require 'json'

PREFIX = /^\./
SETTINGS = OpenStruct.new(YAML.load_file(File.expand_path('./turbot.yaml'))[:settings])

require_relative 'plugin_handler'
Dir["./plugin/**/*cinch_plugin.rb"].each {|file| require file }

bot = Cinch::Bot.new do
  configure do |c|
    c.server          = SETTINGS.server
    c.channels        = SETTINGS.channels
    c.nick            = SETTINGS.nick
    c.plugins.plugins = PluginHandler.plugins
  end

  on :message, /^Open the pod bay doors/i do |m|
    m.reply "I'm sorry, Dave. I'm afraid I can't do that."
  end
end

bot.start
