require 'pry'
require './lib/game_data'
require './lib/game'
require './lib/hangman/hangman_title_scene'
require './lib/hangman/hangman_main_scene'
require './lib/hangman/hangman_ending_scene'

game_data = GameData.new

scenes = []
scenes << HangmanTitleScene.new("gameTitle")
scenes << HangmanMainScene.new("gameMain")
scenes << HangmanEndingScene.new("gameEnd")

game = Game.new("Hangman", scenes, "gameTitle", game_data)
game.start
puts "\n\n"
p game_data.all #examine the data at the end of game
