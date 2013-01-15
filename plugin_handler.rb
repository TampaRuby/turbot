module PluginHandler
  def self.handlers
    @handlers
  end

  def self.add_handler()
    @handlers ||= []
    @handlers << handler
  end
end

class Handler < OpenStruct.new(:name, :matchers, :description)
end
