require './lib/scene'

class ExampleGameTitleScene < Scene
  def initialize(scene_name)
    super(scene_name)
    @state = :play
  end

  def update
    # input = gets.chomp
    input = 'next'
    if input == 'next'
      @state = :change_scene
      @next_scene = "mainGame"
      @logger.debug("Levaing scene: \"#{@scene_name}\"")
    end
  end

  def draw
    puts "Draw Title Screen"
  end
end
