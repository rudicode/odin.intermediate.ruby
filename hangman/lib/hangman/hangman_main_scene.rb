require './lib/scene'
require './lib/hangman/hangman'

class HangmanMainScene < Scene

  def initialize(scene_name, game_io, game_data, logger)
    super(scene_name, game_io, game_data, logger)
    @word_list = Array.new
    @state = :play
  end

  def beginning
    @logger.debug("Beginning scene: \"#{@scene_name}\"")
    load_word_list if @word_list.length < 1
    @hangman = Hangman.new(@word_list.sample)

  end

  def ending
    @logger.debug("Ending scene: \"#{@scene_name}\"")
  end

  def draw
  end

  def update
    @game_io.get_string
    setup_next_scene('gameEnd')
    # @state = :exit
  end

  private
  def valid_word?(line)
    return false if line.include?(' ')
    return false if line.length < 4 || line.length > 12
    return true
  end

  def load_word_list
    begin
      source_file_name = './assets/words.txt'
      source_file = File.open(source_file_name, 'r')
      while !source_file.eof?
         line = source_file.readline.chomp
         if valid_word?(line)
           @word_list << line
         end
      end
      source_file.close
    rescue StandardError => e
      @logger.error("LOAD error: #{e}")
      @logger.info("Falling back to builtin words.")
      @word_list = ['banana', 'tiger', 'painting', 'zebra']
    end
    @logger.info("Words loaded: #{@word_list.length}")
  end

end
