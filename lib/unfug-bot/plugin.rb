module Unfug

  class Plugin
    include Cinch::Plugin

    attr_reader :config

    def initialize(config)
      @config = config
    end

    def match(pattern, options = {})
      super(@config.tigger_character + pattern, options)
    end

  end

end
