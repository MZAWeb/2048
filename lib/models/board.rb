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
      @grid = Array.new(@grid_size) { Array.new(@grid_size) { Cell.new 2**rand(12)  } }
    end

    def move(side)

      changed = false

      # flip the grid if it's moving the Y axis
      @grid = @grid.transpose if side =='up' || side =='down'

      @grid.each_with_index do |row, y|

        #get non-empty cells for the current row
        new_row = row.select { |x| !x.empty? }

        #skip if the row is empty
        next if new_row.empty?

        new_row = merge new_row, 'left' if side=='left' || side=='up'
        new_row = move_row_left new_row if side=='left' || side=='up'

        new_row = merge new_row, 'right' if side=='right' || side =='down'
        new_row = move_row_right new_row if side=='right' || side =='down'

        #If the row actually changed
        if !@grid[y].eql? new_row
          changed=true
          @grid[y] = new_row
        end

      end

      #flip back
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
        2.times{puts} if i < @grid.count-1
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
      Array.new(@grid_size) { Array.new(@grid_size) { Cell.new } }
    end

    def lost?
      #TODO: win?
      #TODO: possible_merges?
      empty_cells.empty?
    end

    def move_row_left new_row
      return new_row.fill new_row.length...@grid_size do
        Cell.new
      end
    end

    def move_row_right new_row
      return new_row.insert(0, *Array.new([0, @grid_size-new_row.length].max) do
        Cell.new
      end)
    end

    # This needs refactor when I'm not sleepy and stupid
    def merge new_row, side

      new_row.reverse! if side == 'right'

      new_row.each_with_index do |cell, i|
        next if cell.empty?
        break if i == new_row.count-1

        if cell.eql? new_row[i+1]
          cell.increment!
          new_row[i+1] = Cell.new
        end

      end

      new_row.reverse! if side == 'right'

      return new_row
    end

  end
end
