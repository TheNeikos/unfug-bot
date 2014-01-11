module Unfug

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

    def validate
      validate_botnick and validate_trigger_character
    end

    private

    #
    # Our channels only allow nick name length to be 8 characters max
    #
    def validate_botnick
      self.botnick.is_a? String and self.botnick.length <= 8
    end

    def validate_trigger_character
      self.tigger_character.is_a? String and self.trigger_character.length == 1
    end

  end

end
