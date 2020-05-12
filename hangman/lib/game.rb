require 'logger'

class Game
  LOG_LIMIT = 1024**2 * 1 # in bytes
  def initialize(game_name, scenes, starting_scene, game_data)
    @state = :starting
    @game_name = game_name
    @game_data = game_data
    @scenes = scenes
    @logger = Logger.new("log/game_log.txt",2 , LOG_LIMIT)
    game_setup
    @scene = @scenes.first
    change_scene(starting_scene)
  end


  def start
    while @state != :exit
      draw()
      update()
      #gets # uncomment this line to step through loop
      if @state == :change_scene
        change_scene(@scene.next_scene)
      end
      if @state == :exit
        @scene.ending # end the scene before exit
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

  private
  def change_scene(scene_name)
    found_scene = false
    @scenes.each_with_index do |scene, index|
      if @scenes[index].scene_name == scene_name
        found_scene = true
        @scene.ending  # ( clean up existing scene before switching to the new one)
        @scene = @scenes[index]
        @logger.debug("Switching to scene: \"#{@scene.scene_name}\"")
        @scene.beginning # ( init new scene, before calling draw() and update())
        @scene.state = :play
        @state = :play
      end
    end
    if !found_scene
      @logger.fatal("Scene: \"#{scene_name}\" NOT FOUND.")
      @state = :exit
    end
  end

  def game_setup
    @logger.level = Logger::DEBUG # DEBUG, INFO, WARN, ERROR, FATAL, UNKNOWN
    @logger.formatter = proc do |severity, datetime, progname, msg|
      severity = " #{severity} " if severity == "ERROR" || severity == "FATAL"
      "#{datetime.strftime("%Y-%m-%dT%T")} : #{@game_name} : #{severity} : #{msg}\n"
    end
    @logger.debug("---------------")
    @logger.debug("Starting Logger")

    # set logger on all scenes
    @scenes.each do |scene|
      scene.logger = @logger # set logger on all scenes
      scene.game_data = @game_data # set game_data on all scenes
    end
    @game_data.logger = @logger
  end

end