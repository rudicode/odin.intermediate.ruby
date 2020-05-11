require './lib/scene'

class ExampleGameMainScene < Scene

  def initialize(scene_name)
    super(scene_name)
    @counter = 0
    @state = :play
  end

  def update
    @counter += 2
    if @counter >= 20
      @state = :exit
    end
  end

  def draw
    puts "Scene2 Counter: #{@counter}"
  end
end
