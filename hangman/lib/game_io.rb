class GameIo
  def initialize(columns, lines)
    @columns = columns
    @lines   = lines
  end

  def clear_screen
    print"\033[2J\033[1;1H" # clear screen and set cursor to 1,1 (lines,columns)
  end

  def get_string(prompt, column, line)
    print "\033[#{line};#{column}H#{prompt}"
    input = gets.chomp
  end

  def put_string(text, column, line)
    print "\033[#{line};#{column}H#{text}"
  end
end
