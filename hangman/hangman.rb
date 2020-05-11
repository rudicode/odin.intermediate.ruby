require './lib/example_game_title_scene'
require './lib/example_game_main_scene'
require "./lib/game"

scenes = []
scenes << ExampleGameTitleScene.new("splashScreen")
scenes << ExampleGameMainScene.new("mainGame")

game = Game.new("SampleGame", scenes, "splashScreen")
game.start
puts "\n\n"
