class Hangman
  attr_reader :solution, :guessed_word, :guesses_left, :letters_used, :max_guesses
  def initialize(word)
    # @solution = word.split("")
    # @guessed_word = Array.new(@solution.length,"_")
    # @letters_used = []
    # @guesses_left = @max_guesses
    @max_guesses = 7 # TODO: should be able to set this from main game
    reset(word)
  end

  def make_guess(letter)
    return if win? || lost?
    return if @letters_used.include?(letter)
    @guesses_left -= 1
    @letters_used << letter
    @solution.each_with_index do |x, index|
      if x == letter
        @guessed_word[index] = letter
        @guesses_left += 1
      end
    end
    @guessed_word = @solution if lost?
  end

  def win?
    @solution == @guessed_word
  end

  def lost?
    @guesses_left < 1
  end

  def reset(word)
    @solution = word.split("")
    @guessed_word = Array.new(@solution.length,"_")
    @letters_used = []
    @guesses_left = @max_guesses
  end

end
