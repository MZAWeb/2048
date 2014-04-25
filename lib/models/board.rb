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

        new_row = Row.new(row.dup)

        new_row.remove_empty!

        next if new_row.empty?

        # Reverse if it's a right move, to operate as if it's a left move
        new_row.reverse! if side=='right' || side =='down'

        new_row.merge! do
          new_cell
        end

        new_row.pad!(@grid_size) do
          new_cell
        end

        # Reverse back
        new_row.reverse! if side=='right' || side =='down'

        # If the row actually changed
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

    def empty_cells
      empty_cells_hash = {}
      @grid.each_with_index do |row, y|
        row.each_with_index { |cell, x|
          empty_cells_hash[Point.new x, y] = cell if cell.empty?
        }
      end
      empty_cells_hash
    end

    def win?
      @grid.each { |row| row.each { |cell| return true if cell.win? } }
      return false
    end

    def inject_random_cell
      e = empty_cells
      return if e.empty?

      key = e.keys.sample

      e[key].increment!
      e[key].increment! if rand(4) == 1

    end

    def default_grid
      Array.new(@grid_size) { Array.new(@grid_size) { new_cell } }
    end

    def lost?
      #TODO: win?
      #TODO: possible_merges?
      empty_cells.empty?
    end

    def new_cell
      Cell.new 0, 2**(@grid_size+7)
    end

  end
end
