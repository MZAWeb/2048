module TwentyFortyEight

  class Row
    attr_reader :value

    def initialize(value)
      @value = value
    end

    # get non-empty cells for the current row
    def remove_empty!
      @value.reject! { |x| x.empty? }
    end

    def empty?
      @value.empty?
    end

    def reverse!
      @value.reverse!
    end

    def eql?(arr)
      return true if arr == @value
    end

    # This needs refactor when I'm not sleepy and stupid
    def merge!
      @value.each_with_index do |cell, i|
        next if cell.empty?
        break if i == @value.count-1

        if cell.eql? @value[i+1]
          cell.increment!
          @value[i+1] = yield
        end
      end

    end

    # fill to a given length with the given block
    def pad!(grid_size)
      @value.fill @value.length...grid_size do
        yield
      end
    end

  end

end
