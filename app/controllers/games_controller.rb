require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @vowels = %w[A E Y U I O]
    @consonants = %w[Q Z W S X D C R F V T G B H N J M K L P]
    @letters = []
    4.times do
      @letters << @vowels.sample
    end
    6.times do
      @letters << @consonants.sample
    end
    @letters.shuffle!
  end

  def score
    @letters_in_word = params[:word].upcase.split
    @letters = params[:letters].split(' ')
    @score = params[:word].length
    @letters_in_word.each do |letter|
      if params[:letters].split(' ').include?(letter)
        @letters.delete_at(@letters.index(letter))
      else
        @answer = "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters].gsub(' ', ', ')}"
      end
      url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
      word_serialized = URI.open(url).read
      word_data = JSON.parse(word_serialized)
      if word_data['found']
        @answer = "Congratulations! #{params[:word].upcase} is a valid English word!"
      else
        @answer = "Sorry but #{params[:word].upcase} does not seem to be a valid English word..."
      end
    end
  end
end
