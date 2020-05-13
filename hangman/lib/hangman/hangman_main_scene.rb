require './lib/scene'
require './lib/colors'
require './lib/hangman/hangman'

class HangmanMainScene < Scene
  include Colors

  def initialize(scene_name, game_io, game_data, logger)
    super(scene_name, game_io, game_data, logger)
    @categories = {}
    @category_text = "Unknown"
    @word_list = Array.new
    @hangman_graphic = Array.new
    @state = :play
  end

  def beginning
    @logger.debug("Beginning scene: \"#{@scene_name}\"")
    load_word_list if @word_list.length < 1
    # @hangman = Hangman.new(@word_list.sample)
    # @category_text = @categories[pick_category]
    @hangman = Hangman.new("Unknown")
    setup_random_word
    setup_hangman_graphic
  end

  def setup_random_word
    @category_text = @categories.keys.sample
    @hangman.reset(@categories[@category_text].sample)
  end

  def ending
    @logger.debug("Ending scene: \"#{@scene_name}\"")
  end

  def draw
    x_pos = 16
    @game_io.clear_screen
    @game_io.put_string("H A N G M A N", 22, 4)
    @game_io.put_string("Category: #{@category_text}", 22,6)
    @game_io.put_string("#{@hangman.guessed_word.join("  ")}", x_pos, 10)
    @game_io.put_string("#{@hangman.letters_used.join(" ")}", 2, 14)
    @game_io.put_string("#{@hangman.solution.join("  ")}", x_pos, 16) # for debug
    draw_hangman(@hangman.guesses_left,2,4)

    if @state == :play || @state == :starting
      @game_io.put_string("Guesses left: #{@hangman.guesses_left}", x_pos, 8)
      @game_io.put_string("Pick a letter: ", x_pos, 12)
    end

    if @state == :finished
      @game_io.put_string("Enter to play again: ", x_pos, 12)
    end
  end

  def update
    input = @game_io.get_string

    if @state == :starting
      @state = :play
    end

    if @state == :finished
      if input == 'save'
        @logger.info("Saving Game...")
        # save the game and quit
        # serialize Hangman??
      end
      #setup new word to play
      # @hangman.reset(@word_list.sample)
      setup_random_word
      @state = :starting
    end

    if @state == :play
      @hangman.make_guess(input)
      @state = :finished if @hangman.win? || @hangman.lost?
    end

    if input == '!' || input == 'quit'
      setup_next_scene('gameEnd')
    end


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
           @word_list << line.downcase
         end
      end
      source_file.close

      # get file list of *.list
      file_list = Dir.glob("./assets/*.list")
      @logger.info("Parsing assets directory, using files: #{file_list}")
      file_list.each do |file|
        source_file = File.open(file, 'r')
        category_name = source_file.readline.chomp # first line in file should be the Category description
        # category_name needs to sanitised before used as a key for the @categories hash
        category_name = sanitize(category_name)
        items = []
        while !source_file.eof?
          line = source_file.readline.chomp
          items << line
        end
        @categories[category_name] = items
        source_file.close
      end
    rescue StandardError => e
      @logger.error("LOAD error: #{e}")
      @logger.info("Falling back to builtin words.")
      @word_list = ['banana', 'tiger', 'painting', 'zebra']
    end
    @logger.info("Words loaded: #{@word_list.length}")
  end

  def sanitize(name)
    # TODO: Allow only [A-Z] [a-z] [0-9] and - (dashes)
    return name
  end

  def draw_hangman(frame_number,column, line)
    frame_number = 0 if @hangman_graphic[frame_number] == nil
    @hangman_graphic[frame_number].each_with_index do |text,index|
      @game_io.put_string("#{BLDYLW}#{text}#{TXTRST}", column, line+index)
    end
  end

  def setup_hangman_graphic
    # special characters   █   │ ³ │ ░ ┌ ─ ┬ ┐ └ ─ ┴ ┘ ─ ┼ ● ┤ ├
    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│    O    "
    hm << "│   \\│/   "
    hm << "│    │     "
    hm << "│   / \\   "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[0] = hm

    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│    O    "
    hm << "│   \\│/   "
    hm << "│    │    "
    hm << "│   /     "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[1] = hm

    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│    O    "
    hm << "│   \\│/   "
    hm << "│    │    "
    hm << "│         "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[2] = hm

    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│    O    "
    hm << "│   \\│/   "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[3] = hm

    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│    O    "
    hm << "│    │/   "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[4] = hm

    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│    O    "
    hm << "│    │    "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[5] = hm

    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│    O    "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[6] = hm

    hm = []
    hm << "┌────┐    "
    hm << "│    │    "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘"
    @hangman_graphic[7] = hm


  end

end
