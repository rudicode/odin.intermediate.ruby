class Hangman
  attr_reader :solution, :correct, :guesses_left, :letters_used, :max_guesses
  def initialize(word)
    @solution = word.split("")
    @correct = Array.new(@solution.length,"_")
    @letters_used = []
    @max_guesses = 7 # TODO: should be able to set this from main game
    @guesses_left = @max_guesses
    # @wrong_guess_counter = 0
    # @max_wrong_guess = 7 # TODO: should be able to set this from main game

  end

  def make_guess(letter)
    return if win? || lost?
    @guesses_left -= 1
    @letters_used << letter
    @solution.each_with_index do |x, index|
      if x == letter
        @correct[index] = letter
      end
    end
  end

  def win?
    @solution == @correct
  end

  def lost?
    @guesses_left < 1
  end

end
