require "hangman/hangman"

RSpec.describe Hangman do
  before(:example) do
    @game = Hangman.new( 'banana' )
  end

  describe '#initialize' do
    it 'sets @solution to single letter array' do
      expect(@game.solution).to eq(['b','a','n','a','n','a'])
    end

    it 'sets @correct to same length as @solution and underscores' do
      expect(@game.correct).to eq(['_','_','_','_','_','_'])
    end
  end

  describe '#make_guess' do

    it 'adds the letter to @letters_used Array' do
      @game.make_guess('a')
      expect(@game.letters_used).to include('a')
    end

    context 'correct guess' do
      it 'updates @correct to reflect correct guess' do
        @game.make_guess('b')
        expect(@game.correct).to eq(['b','_','_','_','_','_'])
      end

      it 'updates @correct to reflect correct guess for multiple letters' do
        @game.make_guess('a')
        expect(@game.correct).to eq(['_','a','_','a','_','a'])
      end
    end

    context 'incorrect guess' do
      it '@correct does not change with wrong guess' do
        @game.make_guess('x')
        expect(@game.correct).to eq(['_','_','_','_','_','_'])
      end
      it 'increments wrong_guess_counter' do
        # @game.make_guess('a')
        expect{ @game.make_guess('a')}.to change {@game.guesses_left}.by(-1)
      end
    end

  end

  describe '#win?' do
    it 'returns false when word has not been guessed' do
      @game.make_guess('x')
      expect(@game.win?).to be_falsy
    end

    it 'returns true when word has been guessed' do
      @game.make_guess('b')
      @game.make_guess('a')
      @game.make_guess('n')
      expect(@game.win?).to be_truthy
    end
  end

  describe '#lost?' do
    it 'returns false if game has -not- exceeded max_wrong_guess' do
      expect(@game.lost?).to be_falsy
    end

    it 'returns true if game has exceeded max_wrong_guess' do
      expect(@game.lost?).to be_falsy
      # make 7 guesses
      @game.make_guess('1')
      @game.make_guess('2')
      @game.make_guess('3')
      @game.make_guess('4')
      @game.make_guess('5')
      @game.make_guess('6')
      expect(@game.lost?).to be_falsy
      @game.make_guess('7')
      expect(@game.lost?).to be_truthy

    end
  end
end
