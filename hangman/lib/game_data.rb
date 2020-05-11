
# To be used for storing game data and persisting it to disk

class GameData
  attr_accessor :logger
  def initialize
    @data = {}
    @logger = nil
  end

  def update(hash)
    if hash.class != Hash
      @logger.warn("#{self}#update : expecting to update Hash but got #{hash.class} : #{hash.inspect}")
      return
    end
    # @logger.debug("#{self}#update : Adding #{hash.inspect}")
    @data.merge!(hash)
  end

  def get(key)
    @data[key]
  end

  def all
    @data
  end
end
