module TwentyFortyEight

  class Cell
    attr_accessor :value

    def initialize(value = 0)
      @value = value
    end

    def increment
      @value = 1 if @value == 0
      @value *= 2
    end

    def empty?
      @value == 0
    end

    def hash
      @value.hash
    end

    def eql?(other_cell)
      return true if other_cell.value == @value
    end

  end

end
