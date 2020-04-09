#!/usr/bin/env ruby

COLS = `tput cols`.to_i
ROWS = `tput lines`.to_i
NUM_DOTS = COLS * ROWS + COLS
NUM_COLORS = 24
ANSI_MAP = Array.new(NUM_COLORS) { |i| "\e[48;5;#{232 + i}m " }

class Scene
  def initialize
    @dots = Array.new(NUM_DOTS) { 0 }
    @buffer = Array.new(NUM_DOTS) { 0 }
  end

  def run
    # srand
    STDOUT.print "\e[?47h\e[?25l"     # use alternate terminal screen output
    loop do
      reset_bottom
      blend
      draw
      sleep 0.01
    end
  ensure
    STDOUT.print "\e[?47l\e[?25h"     # switch back to primary screen
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
    chars = []
    ROWS.times do |y|
      COLS.times do |x|
        dot = @dots[y * COLS + x]
        chars << "\e[#{y};#{x}H#{ANSI_MAP[dot] || ANSI_MAP.last}"
      end
    end
    STDOUT.print "#{chars.join}\e[#{ROWS-1};#{COLS-1}H\e[0m"
  end
end
Scene.new.run
