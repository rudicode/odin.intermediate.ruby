require './lib/scene'
require './lib/colors'

class HangmanTitleScene < Scene
  include Colors

  def initialize(scene_name, game_io, game_data, logger)
    super(scene_name, game_io, game_data, logger)
    @state = :play
  end

  def beginning
    @logger.debug("Beginning scene: \"#{@scene_name}\"")
    @game_io.c_hide
  end

  def ending
    @game_io.c_show
    @logger.debug("Ending scene: \"#{@scene_name}\"")
  end

  def draw
    @game_io.clear_screen
    @game_io.put_string("#{UNDGRN}H A N G M A N#{TXTRST}", 20, 10)
  end

  def update
    @game_io.get_string("")
    # @state = :exit
    setup_next_scene('gameMain')
  end

end
