module TwentyFortyEight

  class Cell
    attr_accessor :value

    COLORS = {
        2 => :red,
        4 => :green,
        8 => :yellow,
        16 => :blue,
        32 => :magenta,
        64 => :cyan,
        128 => :white,
        256 => :light_yellow,
        512 => :light_red,
        1024 => :light_blue,
        2048 => :light_cyan,
    }

    def initialize(value = 0, winner =2048)
      @value = value
      @winner = winner
    end

    def text
      t = empty? ? '·' : @value.to_s

      t.center(4, ' ').colorize(:color => COLORS[@value])
    end

    def increment!
      @value = 1 if @value == 0
      @value *= 2
    end

    def empty?
      @value == 0
    end

    def win?
      @value == @winner
    end

    def hash
      @value.hash
    end

    def eql?(other_cell)
      return true if other_cell.value == @value
    end

  end

end
