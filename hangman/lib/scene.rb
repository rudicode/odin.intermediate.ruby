require './lib/game_io'

class Scene
  attr_accessor :state, :logger, :game_data
  attr_reader :scene_name, :next_scene

  def initialize(scene_name="default")
    @scene_name = scene_name
    @next_scene = ""
    @game_io = GameIo.new()
    @game_data = nil
    @logger = nil
    @state = :starting
  end

  def beginning
    # called whenever switch to this scene occurs
    # used for setup scene before draw(), update() loop starts.
  end

  def ending
    # called whenever switching away from this scene
    # used for clean up and saving state
  end

  def draw
    # called 1st in a loop from Game
    # used for display purposes only.
  end

  def update
    # called 2nd from Game loop.
    # used to get user input and apply any game logic
  end

  private
  def setup_next_scene(scene_name)
    scene_name == :exit ? @state = :exit : @state = :change_scene
    @next_scene = scene_name
  end

end
