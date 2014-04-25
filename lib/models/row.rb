module TwentyFortyEight

  class Row
    attr_reader :value

    def initialize(value, side)
      @value = value
      @side = side
    end

    def empty?
      @value.each do |c|
        return false if !c.empty?
      end
      return true
    end

    def eql?(arr)
      return true if arr == @value
    end

    def merge!(grid_size, &block)

      # remove the empty cells so we group
      # the cells with values together
      remove_empty!

      # Reverse if it's a right move, to operate as if it's a left move...
      @value.reverse! if @side=='right' || @side =='down'

      @value.each_cons(2).to_a.each_with_index do |duo, i|

        next if !duo[0].eql? duo[1]

        duo[0].increment!
        @value.delete_at(i+1)

      end

      # Complete the row with empty cells
      pad!(grid_size, &block)

      #...and reverse back
      @value.reverse! if @side=='right' || @side =='down'

    end

    private

    # get non-empty cells for the row
    def remove_empty!
      @value.reject! { |x| x.empty? }
    end

    # fill to a given length with the given block
    def pad!(grid_size, &block)
      @value.fill @value.length...grid_size do
        block.call
      end
    end

  end

end
