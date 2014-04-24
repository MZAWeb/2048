require_relative 'lib/2048.rb'
require 'io/console'
require 'rubygems'
require 'bundler'

Bundler.require()

module TwentyFortyEight

  class Game

    def initialize
      @board = Board.new
      @board.print
      read_key while (true)
    end

    def read_key
      c = read_char

      case c
        when "\e[A"
          @board.move('up')
        when "\e[B"
          @board.move('down')
        when "\e[C"
          @board.move('right')
        when "\e[D"
          @board.move('left')
        when 'R'
          @board.reset
        when 'D'
          @board.demo
        when 'Q'
          puts 'Bye bye'
          exit 0
      end

      @board.print
      @board.validate

    end

    def read_char
      STDIN.echo = false
      STDIN.raw!

      input = STDIN.getc.chr
      if input == "\e" then
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.echo = true
      STDIN.cooked!

      return input
    end

  end

  Game.new
end