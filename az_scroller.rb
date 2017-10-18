#!/usr/bin/env ruby
COLS = `tput cols`.to_i
ROWS = `tput lines`.to_i

print "\e[?47h"    # use alternate terminal screen output
begin
  az = Array.new(COLS) { |m| "\e[38;5;#{rand(180)+16}m#{(m+31).chr}\e[0m" }
  loop do
    print "\e[2J" # clear screen
    puts([az * ''] * (ROWS - 1))
    az << az.shift
    sleep 0.2
  end
ensure
  print "\e[?47l"  # switch back to primary screen
end
