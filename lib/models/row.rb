module TwentyFortyEight

  class Row
    attr_reader :value

    def initialize(value, side)
      @value = value
      @side = side
    end

    # get non-empty cells for the current row
    def remove_empty!
      @value.reject! { |x| x.empty? }
    end

    def empty?
      @value.empty?
    end

    def eql?(arr)
      return true if arr == @value
    end

    # This needs refactor when I'm not sleepy and stupid
    def merge!(grid_size, &block)

      # Reverse if it's a right move, to operate as if it's a left move...
      @value.reverse! if @side=='right' || @side =='down'

      @value.each_with_index do |cell, i|
        next if cell.empty?
        break if i == @value.count-1

        if cell.eql? @value[i+1]
          cell.increment!
          @value[i+1] = block.call
        end
      end

      pad!(grid_size, &block)

      #...and reverse back
      @value.reverse! if @side=='right' || @side =='down'

    end

    private

    # fill to a given length with the given block
    def pad!(grid_size, &block)
      @value.fill @value.length...grid_size do
        block.call
      end
    end

  end

end
