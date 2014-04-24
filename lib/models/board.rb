module TwentyFortyEight
  class Board

    Point = Struct.new(:x, :y)

    def initialize(grid_size = 4)
      @grid_size = grid_size
      @grid = default_grid
      2.times { inject_random_cell }
    end

    def move(side)

      changed = false

      @grid = @grid.transpose if side =='up' || side =='down'

      @grid.each_with_index do |row, y|

        #get non-empty cells for the current row
        new_row = row.select { |x| !x.empty? }

        next if new_row.empty?

        new_row = move_row_left(new_row) if side=='left' || side=='up'
        new_row = move_row_right(new_row) if side=='right' || side =='down'

        #If the row actually changed
        if !@grid[y].eql? new_row
          changed=true
          @grid[y] = new_row
        end

      end


      @grid = @grid.transpose if side =='up' || side =='down'

      # Add a new random cell only if there was some movement in the board
      inject_random_cell if changed

    end

    def validate
      if lost?
        puts 'You loose'
        exit(0)
      end
    end

    def print
      puts "\e[H\e[2J" #Clear terminal
      puts '-' * 7
      @grid.each do |row|
        puts row.map { |cell| cell.value == 0 ? '·' : cell.value }.join(' ')
      end
      puts '-' * 7
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

    def inject_random_cell
      e = empty_cells
      return if e.empty?

      key = e.keys.sample

      e[key].increment
      e[key].increment if rand(4) == 1

    end

    def default_grid
      Array.new(@grid_size) { Array.new(@grid_size) { Cell.new } }
    end

    def lost?
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

  end
end
