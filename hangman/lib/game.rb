require 'pry'
require 'logger'
# require './lib/game_io'
class Scene
  attr_accessor :state
  attr_reader :scene_name, :next_scene

  def initialize(scene_name="default")
    @scene_name = scene_name
    @next_scene = ""
    @state = :starting
  end

  def update
  end

  def draw
  end

end

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
      @next_scene = "mainGame" # change this to an id string eg. "Level 1" or "Splash Screen"
    end
  end

  def draw
    puts "Title Screen"
  end
end

##########################

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

##########################

class Game
  def initialize
    @state = :starting
    @logger = Logger.new("log/game_log.txt")
    logger_setup
    @scenes = []
    @scenes << ExampleGameTitleScene.new("splashScreen")
    @scenes << ExampleGameMainScene.new("mainGame")
    change_scene("splashScreen")
  end

  def logger_setup
    @logger.level = Logger::DEBUG # DEBUG, INFO, WARN, ERROR, FATAL, UNKNOWN
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime.strftime("%Y-%m-%dT%T")} : #{severity} : #{msg}\n"
    end
    @logger.debug("---------------")
    @logger.debug("Starting Logger")
  end

  def start
    while @state != :exit && @state != :change_scene
      draw()
      update()
      #gets # uncomment to step through loop
      if @state == :change_scene
        change_scene(@scene.next_scene)
      end
    end
    @logger.debug("Finished")
    @logger.debug("Stopping Logger")
    @logger.debug("===============")
    @logger.close
  end

  def update
    @scene.update
    @state = @scene.state
  end

  def draw
    @scene.draw
  end

  def change_scene(scene_name)
    found_scene = false
    @scenes.each_with_index do |scene, index|
      if @scenes[index].scene_name == scene_name
        found_scene = true
        @scene = @scenes[index]
        @scene.state = :play
        @state = :play
        @logger.debug("Switching to scene: \"#{@scene.scene_name}\"")
      end
    end
    if !found_scene
      @logger.error("Scene: \"#{scene_name}\" NOT FOUND.")
      @state = :exit
    end
  end

end
