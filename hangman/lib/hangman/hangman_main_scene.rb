require './lib/scene'

class HangmanMainScene < Scene

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
  end

  def update
    @game_io.get_string
    setup_next_scene('gameEnd')
    # @state = :exit
  end

end
