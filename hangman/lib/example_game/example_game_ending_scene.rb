require './lib/scene'
class ExampleGameEndingScene < Scene
  def beginning
    @guesses = @game_data.get(:guesses)
  end

  def ending
  end

  def draw
    @game_io.clear_screen
    @game_io.put_string("THE END -- Sample Game", 3, 4)
    @game_io.put_string("You guessed the number in #{@guesses} tries.", 2, 6)
  end

  def update
    input = @game_io.get_string()
    @state = :exit
  end
end
