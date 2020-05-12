#!/usr/bin/env ruby

# word_validator

def valid_word?(line)
  return false if line.include?(' ')
  return false if line.length < 4 || line.length > 12
  return true
end

##### main #####
if ARGV.length != 1 && ARGV.length != 2
  puts "\nUsage: word_validator SOURCE DESTINATION\n\n"
  puts "Please provide a source file and destination file."
  puts "File should contain a list of words, one word per line."
  puts "Lines with spaces will be discarded."
  puts "Lines with words <4 characters or >12 will be discarded."
  exit(1)
end

source_file_name = ARGV[0]
destination_file_name = ARGV[1]

source_file = File.open(source_file_name, 'r')

if ARGV.length == 1
  destination_file = IO.new(1)  # use STDOUT if no destination file used
else
  destination_file = File.open(destination_file_name, "w")
end


lines_processed = 0
words_validated = 0
words_removed = []

while !source_file.eof?
   line = source_file.readline
   if valid_word?(line.chomp)
     destination_file.puts line
     words_validated += 1
   else
     words_removed << line.chomp
   end
   lines_processed += 1
end

source_file.close
destination_file.close

if ARGV.length == 2
  # only output report to STDOUT if writing to destination file
  puts "Lines processed: #{lines_processed}"
  puts "Words validated: #{words_validated}"
  puts "\nWords removed  : #{words_removed.length}"
  puts "These words removed:"
  puts words_removed.join(', ')
end
