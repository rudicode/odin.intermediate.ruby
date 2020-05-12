require './lib/scene'

class HangmanTitleScene < Scene

  def initialize(scene_name)
    super(scene_name)
    @state = :play
  end

  def beginning
    @logger.debug("Beginning scene: \"#{@scene_name}\"")
  end

  def ending
    @logger.debug("Ending scene: \"#{@scene_name}\"")
  end

  def draw
    @game_io.clear_screen
    @game_io.put_string("H A N G M A N", 20, 10)
  end

  def update
    @game_io.get_string("")
    # @state = :exit
    setup_next_scene('gameMain')
  end

end
