module PluginHandler
  def self.plugins
    @plugins ||= []
  end

  def self.add_plugin(plugin)
    self.plugins << plugin
  end
end

class PluginCommand
  attr_accessor :matchers, :description

  def initialize(matchers, description)
    self.matchers    = matchers
    self.description = description
  end
end
