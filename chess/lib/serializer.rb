# frozen_string_literal: true

# lib/serializer.rb
module Serializer
  def filename_prompt
    loop do
      print 'Name your save: '
      name = gets.chomp
      return name && break if name.match?(/^[0-9a-zA-Z_\- ]+$/)

      # if filename is not valid:
      puts 'Invalid name!'
    end
  end

  def save_game(game)
    filename = filename_prompt
    Dir.mkdir 'saves' unless Dir.exist? 'saves'
    File.open("saves/#{filename}.yaml", 'w') { |file| file.write YAML.dump(game) }
    puts "Your game, '#{filename}', has been saved."
  end

  def choose_game
    puts '- [#] time when game was saved'
    saved_games = Dir.glob('saves/*.*')
    saved_games.each_with_index do |filename, index|
      puts "- [#{index + 1}] #{filename.delete_prefix('saves/').delete_suffix('.yaml')}"
    end
    print 'Enter the # of the game you would like to play: '
    validate_game_choice(gets.chomp, saved_games)
  end

  def validate_game_choice(input, saved_games)
    loop do
      if input.split('').all? { |character| character.match(/[0-9]/) } && saved_games[input.to_i - 1].nil? == false
        load_game(input.to_i - 1, saved_games)
      else
        print 'Game does not exist, choose again: '
        validate_game_choice(gets.chomp, saved_games)
      end
    end
  end

  # VERSION 1

  # def load_game
  #   user_selection = choose_game
  #   YAML.safe_load(
  #     File.read(user_selection),
  #     permitted_classes: [Game]
  #   )
  # end

  # VERSION 2

  def load_game(input, saved_games)
    yaml = YAML.safe_load(
      File.read(saved_games[input]),
      permitted_classes: [Game]
    )
    # self.incorrect_guesses = yaml[0][0]
    # self.guess_count = yaml[0][1]
    # self.correct_guesses = yaml[0][2]
    # self.word_key = yaml[0][3]
    File.delete(saved_games[input])
    yaml
    # prompt_guess
  end
end
