require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = [ ]
    alphabet_array = ('A'..'Z').to_a
    10.times { @grid << alphabet_array.sample }
  end

  def score
    word = params[:word].upcase
    grid = params[:grid]
    session[:score] ||= 0
    if included?(word, grid)
      if english_word?(word)
        @message = "Congratulations! #{word} is a valid English word!"
        session[:score] += 1
      else
        @message = "Sorry but #{word} does not seem to be a valid English word..."
      end
    else
      @message = "Sorry but #{word} can't be build out of #{grid}"
    end
    @score = session[:score]
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
