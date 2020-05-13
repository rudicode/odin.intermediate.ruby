require 'pry'
require './lib/game_data'
require './lib/game_io'
require './lib/game'
require './lib/hangman/hangman_title_scene'
require './lib/hangman/hangman_main_scene'
require './lib/hangman/hangman_ending_scene'

system('tput smcup') # save screen for later

game_name = 'Hangman'

# setup logger
LOG_LIMIT = 1024**2 * 1 # in bytes
logger = Logger.new("log/game_log.txt",2 , LOG_LIMIT)
logger.level = Logger::DEBUG # DEBUG, INFO, WARN, ERROR, FATAL, UNKNOWN
logger.formatter = proc do |severity, datetime, progname, msg|
  severity = " #{severity} " if severity == "ERROR" || severity == "FATAL"
  "#{datetime.strftime("%Y-%m-%dT%T")} : #{game_name} : #{severity} : #{msg}\n"
end
logger.debug("---------------")
logger.debug("Starting Logger")

game_data = GameData.new(logger)
game_io = GameIo.new(logger)

# create array of scenes
scenes = []
scenes << HangmanTitleScene.new("gameTitle", game_io, game_data, logger)
scenes << HangmanMainScene.new("gameMain", game_io, game_data, logger)
scenes << HangmanEndingScene.new("gameEnd", game_io, game_data, logger)

game = Game.new(game_name, scenes, "gameTitle", game_data, logger)
game.start
system('tput rmcup') # restore saved screen

logger.debug("Finished")
logger.debug("Stopping Logger")
logger.debug("===============")
logger.close
# debug game_data without using logger
puts "\n\ngame_data:"
p game_data.all  # examine the data at the end of game
