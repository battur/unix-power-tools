#!/usr/bin/ruby
require 'rubygems'
require 'trollop'

opts = Trollop::options do
  banner <<-EOS
Flipflops matrix of text.

Author: Battur Sanchin. Jan 13, 2011

Example:
    Given:
        one,two,three,four
        1,2,3,4
        ichi,ni,san,shi
    Output:
        one,1,ichi
        two,2,ni
        three,3,san
        four,4,shi

Usage:
      flipflop --file abc.txt --ifs input_fied_separator --ofs output_field_separator
      cat abc.txt | flipflop -i , -o :

Comment:
      This command comes handy if you're dealing with long  insert SQL statement.
      Example:

      query.txt:
      insert into some_table (col1,col2,col3,col4,col5,col6,col7,col8,col9)
      values (12354,65454,13546,0,NULL,1,4657641,1500,321351);

      flipflop -o ", " -f query.txt # would bring:
      insert into some_table(col1, values(12354
      col2, 65454
      col3, 13546
      col4, 0
      col5, NULL
      col6, 1
      col7, 4657641
      col8, 1500
      col9), 321351);

      Once, you've finished editing, flipflop it again. It will transform
      into the insert SQL statement again :)


where [options] are:
EOS

  opt :ifs, "input field separator", :type => :string, :default => ','
  opt :ofs, "output field separator", :type => :string
  opt :file, "file name", :type => :string, :default => nil
end


# input: file or input stream (pipe)
content = (opts[:file] ? open(opts[:file]).readlines : $stdin.readlines)
maxcol, line_count  = 0, content.size
opts[:ofs] ||= opts[:ifs] # if ofs is not defined, use same separator as ifs
field_separator = opts[:ifs] == "space" ? /\s+/ : opts[:ifs]
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
