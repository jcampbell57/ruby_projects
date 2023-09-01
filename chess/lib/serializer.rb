# frozen_string_literal: true

# lib/serializer.rb
module Serializer
  require 'yaml'

  def filename_prompt
    loop do
      print 'Name your save: '
      name = gets.chomp
      return name if name.match?(/^[0-9a-zA-Z_\- ]+$/)

      # if filename is not valid:
      puts 'Invalid name!'
    end
  end

  def save_game(game)
    filename = filename_prompt
    Dir.mkdir 'chess/saves' unless Dir.exist? 'chess/saves'
    File.open("chess/saves/#{filename}.yaml", 'w') { |file| file.write YAML.dump(game) }
    puts "Your game, '#{filename}', has been saved."
  end

  def choose_game
    puts '- [#] Game name'
    saved_games = Dir.glob('chess/saves/*.*')
    saved_games.each_with_index do |filename, index|
      puts "- [#{index + 1}] #{filename.delete_prefix('chess/saves/').delete_suffix('.yaml')}"
    end
    print "Enter 'exit' the # of the game you would like to play: "
    validate_game_choice(gets.chomp, saved_games)
  end

  def validate_game_choice(input, saved_games)
    loop do
      if input.downcase == 'exit'
        exit
      elsif input.split('').all? { |character| character.match(/[0-9]/) } && saved_games[input.to_i - 1].nil? == false
        load_game(input.to_i - 1, saved_games)
      else
        print 'Game does not exist, choose again: '
        validate_game_choice(gets.chomp, saved_games)
      end
    end
  end

  def load_game(input, saved_games)
    yaml = YAML.safe_load(
      File.read(saved_games[input]),
      permitted_classes: [Bishop, Board, Game, King, Knight, Pawn, Queen, Rook],
      aliases: true
    )
    File.delete(saved_games[input])
    yaml.turn_loop
  end
end
