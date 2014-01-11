require "cinch"
require "yaml"
require "http"
require "daemons"

class Config < YAML

  [ :botnick , :channels, :trigger_character, :plugins, :server ].each do |sym|
    self.define_method(sym, lambda { self[sym.to_s] } )
  end

end

class BotRunner

  attr_reader :bots, :configs

  def initialize(configs)
    @configs = configs
    @configs.each do |c|
      (@bots ||= []) << gen_bot_for_config c # ;-) :P
    end
  end

  def strs_to_consts(strs)
    strs.map do |s|
      begin
        Object.const_get s
      rescue NameError
        nil
      end
    end.compact
  end

  def gen_bot_for_config c
    Cinch::Bot.new do
      configure do |conf|
        conf.server = c.server
        conf.channels = c.channels
        conf.nick = c.botnick
        conf.plugins = strs_to_consts c.plugins
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
