module TwentyFortyEight
  class Board

    Point = Struct.new(:x, :y)

    def initialize(grid_size = 4)
      @grid_size = grid_size
      reset
    end

    def reset
      @grid = default_grid
      2.times { inject_random_cell }
    end

    def demo
      @grid = Array.new(@grid_size) { Array.new(@grid_size) { Cell.new 2**rand(@grid_size+7), 2**(@grid_size+7) } }
    end

    def move(side)

      changed = false

      # flip the grid if it's moving the Y axis so we can operate as if it's the X axis
      @grid = @grid.transpose if side =='up' || side =='down'

      @grid.each_with_index do |row, y|

        new_row = Row.new(row.dup, side)

        # Nothing to do if the row is all empty cells
        next if new_row.empty?

        # Merge equal cells together
        new_row.merge! @grid_size do
          new_cell
        end

        # Check if the row actually changed and if so
        # replace it with the newly generated row
        if !@grid[y].eql? new_row
          changed=true
          @grid[y] = new_row.value
        end

      end

      # flip back
      @grid = @grid.transpose if side =='up' || side =='down'

      # Add a new random cell only if there was some movement in the board
      inject_random_cell if changed

    end

    def validate
      if win?
        puts 'You won'.colorize(:color => :yellow).on_blue.blink.underline
        exit(0)
      end

      if lost?
        puts 'You lost'.colorize(:color => :yellow).on_red.blink.underline
        exit(1)
      end
    end

    def print
      puts "\e[H\e[2J" #Clear terminal
      @grid.each_with_index do |row, i|
        puts row.map { |cell| cell.text }.join(' '*5)
        2.times { puts } if i < @grid.count-1
      end
      puts
      puts 'Move with the arrow keys. R to reset. Q to quit.'
    end

    private

    # returns a hash with x,y points to empty cells
    def empty_cells
      empty_cells_hash = {}
      @grid.each_with_index do |row, y|
        row.each_with_index { |cell, x|
          empty_cells_hash[Point.new x, y] = cell if cell.empty?
        }
      end
      empty_cells_hash
    end

    # Injects a random cell in a random empty cell
    def inject_random_cell
      e = empty_cells
      return if e.empty?

      key = e.keys.sample

      e[key].increment!
      e[key].increment! if rand(4) == 1

    end

    # Builds the basic grid
    def default_grid
      Array.new(@grid_size) { Array.new(@grid_size) { new_cell } }
    end

    def lost?
      empty_cells.empty? && !merge_possible?
    end

    def win?
      @grid.each { |row| row.each { |cell| return true if cell.win? } }
      return false
    end

    def merge_possible?
      @grid.each do |row|
        return true if row.chunk { |c| c.value }.map(&:first).count != row.count
      end

      # flip the grid if it's moving the Y axis so we can operate as if it's the X axis
      @grid = @grid.transpose

      @grid.each do |row|
        if row.chunk { |c| c.value }.map(&:first).count != row.count
          # flip back
          @grid = @grid.transpose
          return true
        end
      end

      # flip back
      @grid = @grid.transpose

      return false

    end

    # Helper to create a new empty cell
    def new_cell
      Cell.new 0, 2**(@grid_size+7)
    end

  end
end
