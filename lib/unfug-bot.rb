require "cinch"
require "yaml"
require "http"
require "daemons"

class Config < YAML

  [ :botnick , :channels, :trigger_character, :plugins, :server ].each do |sym|
    self.define_method(sym, lambda { self[sym.to_s] } )
  end

  def available_plugins
    self.plugins.map do |pluginname|
      begin
        Object.get_const pluginname
      rescue NameError
        nil
      end
    end.compact
  end

end

class BotRunner

  attr_reader :bots, :configs

  def initialize(configs)
    @configs = configs
    @configs.each do |c|
      (@bots ||= []) << gen_bot_for_config(c)
    end
  end

  def gen_bot_for_config c
    Cinch::Bot.new do
      configure do |conf|
        conf.server = c.server
        conf.channels = c.channels
        conf.nick = c.botnick
        conf.plugins = c.available_plugins
        # AWESOME! ikr
      end
    end
  end

  def run
    @bots.map(&:start)
  end

  def stop
    @bots.map(&:quit)
  end

end
