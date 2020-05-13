require './lib/scene'

class HangmanEndingScene < Scene

  def initialize(scene_name, game_io, game_data, logger)
    super(scene_name, game_io, game_data, logger)
    @state = :play
  end

  def beginning
    @logger.debug("Beginning scene: \"#{@scene_name}\"")
  end

  def ending
    @game_io.clean_up
    @logger.debug("@game_io.clean_up")
    @logger.debug("Ending scene: \"#{@scene_name}\"")
  end

  def draw
  end

  def update
    @state = :exit
  end

end
