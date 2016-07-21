#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# phases = %w{🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘}
phases = (0x1F311..0x1F318).to_a.collect{|c| [c].pack('U*')}
clear_line = "\r\e[0K"

1000.times do |i|
  phase = phases[i % phases.size]
  print "#{clear_line} #{phase}\t#{i} #{phase.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join}"
  sleep rand / 10.0
end
