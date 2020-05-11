require 'logger'

class Game
  LOG_LIMIT = 1024**2 * 1 # in bytes
  def initialize(game_name, scenes, starting_scene)
    @state = :starting
    @game_name = game_name
    @scenes = scenes
    @logger = Logger.new("log/game_log.txt",2 , LOG_LIMIT)
    logger_setup
    change_scene(starting_scene)
  end


  def start
    while @state != :exit && @state != :change_scene
      draw()
      update()
      #gets # uncomment this line to step through loop
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

  private
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
      @logger.fatal("Scene: \"#{scene_name}\" NOT FOUND.")
      @state = :exit
    end
  end

  def logger_setup
    @logger.level = Logger::DEBUG # DEBUG, INFO, WARN, ERROR, FATAL, UNKNOWN
    @logger.formatter = proc do |severity, datetime, progname, msg|
      severity = " #{severity} " if severity == "ERROR" || severity == "FATAL"
      "#{datetime.strftime("%Y-%m-%dT%T")} : #{@game_name} : #{severity} : #{msg}\n"
    end
    @logger.debug("---------------")
    @logger.debug("Starting Logger")

    # set logger on all scenes
    @scenes.each do |scene|
      scene.logger = @logger
    end
  end

end
