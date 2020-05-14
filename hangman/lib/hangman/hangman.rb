class Hangman
  attr_reader :solution, :guessed_word, :guesses_left, :letters_used, :max_guesses
  def initialize(word)
    @max_guesses = 7 # TODO: should be able to set this from main game
    reset(word)
  end

  def make_guess(letter)
    return if letter.length > 1
    return if win? || lost?
    return if @letters_used.include?(letter.downcase)
    return if @guessed_word.include?(letter) || @guessed_word.include?(letter.downcase)

    letter_matched = nil
    @solution.each_with_index do |x, index|
      if x.downcase == letter.downcase
        @guessed_word[index] = x
        letter_matched = true
      end
    end
    if !letter_matched
      @letters_used << letter.downcase
      @guesses_left -= 1
    end
    # @guessed_word = @solution if lost? # reveal word after loss
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
    @guessed_word.each_index {|x| @guessed_word[x] = " " if @solution[x] == " " }
    @letters_used = []
    @guesses_left = @max_guesses
  end

end
