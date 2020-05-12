require './lib/scene'

class TemplateScene < Scene

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
  end

end
