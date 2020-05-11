require './lib/scene'

class ExampleGameMainScene < Scene

  def initialize(scene_name)
    super(scene_name)
    @guesses = 0
    @answer = 0
    @rand_size = nil
    @state = :play
  end

  def beginning
    @rand_size = @game_data.get(:rand_size)
  end

  def ending
    @game_data.update(guesses: @guesses, answer: @answer)
  end

  def draw
    @game_io.clear_screen
    @game_io.put_string("Sample Game", 8, 4)
    @game_io.put_string("No. of guesses so far: #{@guesses}", 2, 6)
    @game_io.put_string("Guess the number between 1 and #{@rand_size}: ", 2, 8)
  end

  def update
    input = @game_io.get_string()
    @guesses += 1
    @answer = rand(@rand_size)+1
    if input.to_i == @answer
      @state = :change_scene
      @next_scene = "gameEnd"
    end
  end

end
