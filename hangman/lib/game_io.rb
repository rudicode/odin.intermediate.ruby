require './lib/colors'

class GameIo

  include Colors

  def initialize(logger)
    @logger = logger
    @screen_columns = `tput cols`   # get columns from system
    @screen_lines   = `tput lines`  # get lines from system
  end

  def clear_screen
    print"\033[2J\033[1;1H" # clear screen and set cursor to 1,1 (lines,columns)
  end

  def get_string(prompt=nil, column=1, line=1)
    print "\033[#{line};#{column}H#{prompt}" if prompt
    input = gets.chomp
  end

  def put_string(text, column, line)
    print "\033[#{line};#{column}H#{TXTGRN}#{text}#{TXTRST}"
  end

  def clean_up
    print "#{CSHOW}#{TXTRST}"
    # TODO position cursor to bottom of screen
    # shell example
    # `tput smcup`    # Save the display
    # `tput rmcup`    # Restore the display
  end
end
