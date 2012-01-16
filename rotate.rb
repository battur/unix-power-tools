#!/usr/bin/ruby
require 'rubygems'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Rotates text 90 degrees clock wise.

Author: Battur Sanchin. Jan 13, 2011

Example:
    Given:
        one two three four
        1 2 3 4
        ichi ni san shi

    Output:
        one 1 ichi
        two 2 ni
        three 3 san
        four 4 shi

Usage:
      rotate --file abc.txt --fs input_fied_separator --ofs output_field_separator
      cat abc.txt | rotate -f , -o :

Comment:
      This command comes handy if you're dealing with long SQL
      insert statement. Rotate the query, crud the column/value
      pair instantly. Example:

      query.txt:
      insert into some_table(col1, col2, col3, col4, col5, col6, col7, col8, col9)
      values(val1, val2, val3, val4, val5, val6, val7, val8, val9);

      rotate -o ", " -i query.txt # would bring:
      insert into some_table(col1, values(val1
      col2, val2
      col3, val3
      col4, val4
      col5, val5
      col6, val6
      col7, val7
      col8, val8
      col9), val9);

      Once, you've finished, rotate it again. It will transform
      to insert SQL statement again :)


where [options] are:
EOS

  opt :fs, "input field separator", :type => :string, :default => ','
  opt :ofs, "output field separator", :type => :string
  opt :file, "file name", :type => :string, :default => nil
end


# it can run just like the unix cat command. reads from file or pipe.
content = (opts[:file] ? open(opts[:file]).readlines : $stdin.readlines)
maxcol, line_count  = 0, content.size
opts[:ofs] ||= opts[:fs] # if ofs is not defined, use same separator as fs
field_separator = opts[:fs] == "space" ? /\s+/ : opts[:fs]
maxcol = content.collect { |line| line.split(field_separator).size }.max

# will fail if input is not NxM matrix
(1..maxcol).each do |col|
  (1..line_count).each do |line|
    printf("%s", content[line - 1].strip.split(field_separator)[col - 1].strip)
    printf("#{opts[:ofs]}") if line < line_count
  end
  puts
end

exit 0