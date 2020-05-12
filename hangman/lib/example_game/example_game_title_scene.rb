require './lib/scene'

class ExampleGameTitleScene < Scene
  def initialize(scene_name)
    super(scene_name)
    @state = :play
  end

  def beginning
  end

  def ending
    @logger.debug("Ending scene: \"#{@scene_name}\"")
  end

  def draw
    @game_io.clear_screen
    @game_io.put_string("Sample Game Title Screen", 5,4)
    @game_io.put_string("Press Enter to continue", 5,8)
  end

  def update
    input = @game_io.get_string()
    if input
      setup_next_scene("mainGame")
      @game_data.update({rand_size: 4})
    end
  end

end
