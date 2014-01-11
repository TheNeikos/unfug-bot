module Unfug

  class Bot < Cinch::Bot

    def message_all(str)
      self.channels.each { |c| msg(c, str) } if str.is_a? String
      nil
    end

  end

end
