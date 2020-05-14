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
    x_pos = 20
    @game_io.clear_screen
    draw_hangman(@hangman.guesses_left,4,5)
    @game_io.put_string("#{UNDGRN}H A N G M A N#{TXTRST}", 14, 2)
    @game_io.put_string("#{BLDBLU}#{@category_text}#{TXTRST}", x_pos,6)
    @game_io.put_string("#{TXTRED}#{@hangman.letters_used.join(" ")}#{TXTRST}", 2, 14)
    # @game_io.put_string("#{BLDBLK}#{@hangman.solution.join("  ")}#{TXTRST}", x_pos, 36) # for debug

    if @state == :play || @state == :starting
      @game_io.put_string("#{BLDWHT}#{@hangman.guessed_word.join("  ")}#{TXTRST}", x_pos, 10)
      @game_io.put_string("#{TXTWHT}Guesses", 4, 16)
      @game_io.put_string("remaining", 3, 17)
      @game_io.put_string("#{@hangman.guesses_left}#{TXTRST}", 7, 18)
      @game_io.put_string("#{TXTWHT}Guess a letter: #{BLDWHT}", x_pos, 14)
    end

    if @state == :finished
      @game_io.put_string("#{TXTWHT}Enter to play again: #{TXTRST}", x_pos, 14)
      @game_io.put_string("#{BLDWHT}#{@hangman.solution.join("  ")}#{TXTRST}", x_pos, 10)
      if @hangman.win?
        @game_io.put_string("#{BLDGRN}Congratulations, you WIN this round!  #{TXTRST}", 5, 17)
      else
        @game_io.put_string("#{TXTRED}Sorry, you LOSE this round!  #{TXTRST}", 8, 17)
      end
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
    draw_graphic(@hangman_graphic[7], column, line)
    return if @hangman_graphic[frame_number] == nil
    return if frame_number >= 7 || frame_number < 0
    draw_graphic(@hangman_graphic[frame_number], column+4, line+1)
  end

  def draw_graphic(arr, column, line)
    arr.each_with_index do |text,index|
      @game_io.put_string("#{text}", column, line+index)
    end

  end

  def setup_hangman_graphic
    # special characters   █   │ ³ │ ░ ┌ ─ ┬ ┐ └ ─ ┴ ┘ ─ ┼ ● ┤ ├
    hm = []
    hm << "#{BLDYLW}"
    hm << " O "
    hm << "\\│/"
    hm << " │ "
    hm << "/ \\ #{TXTRST}"
    @hangman_graphic[0] = hm

    hm = []
    hm << "#{BLDYLW}"
    hm << " O "
    hm << "\\│/"
    hm << " │ "
    hm << "/   #{TXTRST}"
    @hangman_graphic[1] = hm

    hm = []
    hm << "#{BLDYLW}"
    hm << " O "
    hm << "\\│/"
    hm << " │ #{TXTRST}"
    @hangman_graphic[2] = hm

    hm = []
    hm << "#{BLDYLW}"
    hm << " O "
    hm << "\\│/#{TXTRST}"
    @hangman_graphic[3] = hm

    hm = []
    hm << "#{BLDYLW}"
    hm << " O "
    hm << " │/#{TXTRST}"
    @hangman_graphic[4] = hm

    hm = []
    hm << "#{BLDYLW}"
    hm << " O "
    hm << " │ #{TXTRST}"
    @hangman_graphic[5] = hm

    hm = []
    hm << "#{BLDYLW}"
    hm << " O #{TXTRST}"
    @hangman_graphic[6] = hm

    hm = []
    hm << "#{TXTYLW}┌────┐    "
    hm << "│    │    "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "│         "
    hm << "├──────┐"
    hm << "└──────┘#{TXTRST}"
    @hangman_graphic[7] = hm


  end

end
