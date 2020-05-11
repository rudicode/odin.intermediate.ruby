class Scene
  attr_accessor :state, :logger
  attr_reader :scene_name, :next_scene

  def initialize(scene_name="default")
    @scene_name = scene_name
    @next_scene = ""
    @logger = nil
    @state = :starting
  end

  def update
  end

  def draw
  end

end
