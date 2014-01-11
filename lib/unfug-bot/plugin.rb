module Unfug

  module Plugins

    class Echo
      include Cinch::Plugin

      match "echo"

      def execute m
        m.reply m.message
      end
    end

  end

end
