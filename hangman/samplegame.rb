require 'pry'
require './lib/game_data'
require './lib/game'
require './lib/example_game/example_game_title_scene'
require './lib/example_game/example_game_main_scene'
require './lib/example_game/example_game_ending_scene'

game_data = GameData.new

scenes = []
scenes << ExampleGameTitleScene.new("splashScreen")
scenes << ExampleGameMainScene.new("mainGame")
scenes << ExampleGameEndingScene.new("gameEnd")

game = Game.new("SampleGame", scenes, "splashScreen", game_data)
game.start
puts "\n\n"
p game_data.all #examine the data at the end of game
