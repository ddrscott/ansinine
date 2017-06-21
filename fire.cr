#!/usr/bin/env crystal

COLS = `tput cols`.to_i
ROWS = `tput lines`.to_i
NUM_DOTS = COLS * ROWS + COLS
NUM_COLORS = 24
ANSI_MAP = Array.new(NUM_COLORS) { |i| "\e[48;5;#{232 + i}m " }

class Scene
  def initialize
    @dots = Array(Int32).new(NUM_DOTS) { 0 }
    @buffer = Array(Int32).new(NUM_DOTS) { 0 }
  end

  def run
    # srand
    STDOUT.print "\e[?47h"     # use alternate terminal screen output
    loop do
      reset_bottom
      blend
      draw
      sleep 0.12321
    end
  ensure
    STDOUT.print "\e[?47l"     # switch back to primary screen
  end

  def reset_bottom
    COLS.times { |x| @dots[NUM_DOTS - x - 1] = rand(NUM_COLORS) }
  end

  def value_at(idx, offset)
    pos = idx + offset
    (pos >= 0 && pos < NUM_DOTS) ? @dots[pos] : @dots[idx]
  end

  def blend
    NUM_DOTS.times do |i|
      above = value_at(i, COLS)
      below = value_at(i, -COLS)
      right = value_at(i, 1)
      left = value_at(i, -1)

      @buffer[i - COLS] = (above + below + left + right + @dots[i]) / 5 
    end
    # swap buffers
    @buffer, @dots = @dots, @buffer
  end

  def draw
    chars = [] of String
    ROWS.times do |y|
      COLS.times do |x|
        dot = @dots[y * COLS + x]
        chars << (ANSI_MAP[dot] || ANSI_MAP.last)
      end
      chars << "\n" unless y == ROWS - 1
    end
    STDOUT.print "\e[2J\e[0;0H#{chars.join}\e[#{ROWS};#{COLS}H\e[0m"
    STDOUT.flush
  end
end
Scene.new.run
