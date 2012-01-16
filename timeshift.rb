#!/usr/bin/ruby
scriptie_description = <<-eos.gsub(/#( |)/,'')
###########################################################
# shift.rb
#
# Time shift scriptie for out ot sync subtitles.
# Conversion will be printed to standard output stream.
# Author: Battur Sanchin (http://twitter.com/battur)
# July 08, 2011
#
# Usage:
#    ./shift.rb seconds_to_shift < your_file_path
#
# Example:
#   ./shift.rb -125 < bourne_ultimatum_2007.srt > new.srt
#   ./shift.rb +45  < batman_the_dark_knight_2008.srt
#
# Subtitle content might look like:
#
#   776
#   1:45:48,275 --> 1:45:50,895
#   <i>Meanwhile, a mystery
#   surrounds the fate of David Webb,</i>
#
#   777
#   1:45:50,896 --> 1:45:52,812
#   <i>also known
#   as Jason Bourne,</i>
#
#   778
#   1:45:52,813 --> 1:45:55,668
#   <i>the source behind the
#   exposure of the Blackbriar program.</i>
#
# License: Free Software ;)
###########################################################
eos


unless ARGV.size > 0 && ARGV[0] =~ /^[+-]?\d+$/
  puts scriptie_description
  exit 1
end

SEPARATOR = " --> "
SIXTY = 60
seconds_to_shift = ARGV[0].to_i

def shift(time, seconds_to_shift)
  stamp, mills = time.split /,/
  hour, min, sec = stamp.split(/:/).collect{ |e| e.to_i }
  sec = seconds_to_shift + sec + min * SIXTY + hour * SIXTY * SIXTY
  sec = 0 if sec < 0
  hour = sec / (SIXTY * SIXTY)
  min = (sec - (hour * SIXTY * SIXTY)) / SIXTY
  sec = sec - hour * SIXTY * SIXTY - min * SIXTY
  "#{hour}:#{min}:#{sec},#{mills}"
end

for line in $stdin.readlines do
  if line =~ /^\d{2}:\d{2}:\d{2},\d{3}#{SEPARATOR}\d{2}:\d{2}:\d{2},\d{3}/
    head, tail = line.split(SEPARATOR).collect { |e| shift(e, seconds_to_shift) }
    puts "#{head}#{SEPARATOR}#{tail}"
  else
    puts line
  end
end

exit 0
