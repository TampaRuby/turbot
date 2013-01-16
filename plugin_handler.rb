module PluginHandler
  def self.plugins
    @plugins ||= []
  end

  def self.add_plugin(plugin)
    self.plugins << plugin
  end

  def self.commands
    plugins.inject([]) {|m,p| m += Array(p.help) }
  end

  def self.matchers
    commands.collect{|c| c.matchers}
  end

  def self.command(matcher)
    commands.detect{|c| c.matchers =~ /#{matcher}/}
  end
end

class PluginCommand
  attr_accessor :matchers, :description

  def initialize(matchers, description)
    self.matchers    = matchers
    self.description = description
  end

  def display_row
    [matchers, description]
  end
end
