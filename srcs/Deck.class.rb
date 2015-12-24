require 'nokogiri'
require 'singleton'

##################################################################################
# This Decks class should be used to contain all hearthstone decks with following#
#  infos:                                                                        #
#     name, class, type, rating, cost, last updated, url                         #
##################################################################################
class Deck
  ############################################################################
  #                             Initializer                                  #
  ############################################################################
  def initialize(name, classname, type, rating, cost, lastupdated, url)
    @name = name
    @classname = classname
    @type = type
    @rating = rating
    @cost = cost
    @lastupdated = lastupdated
    @url = url
    @cards = []
    setAllCards()
  end

  ############################################################################
  #                             Public Methods                               #
  ############################################################################
  public
  def print
    printf "## %-20.20s  %-10.10s %-10.10s %-8.8s %-7.7s %-15.15s ##\n",
        @name, @classname, @type, @rating, @cost, @lastupdated
    puts @url
    @cards.each do |card|
      printf "%s \n", card
    end
  end

  ############################################################################
  #                             Getters/Setters                              #
  ############################################################################
  def cards
    @cards
  end

  def name
    @name
  end

  def rating
    @rating
  end

  def cost
    @cost
  end

  def lastupdated
    @lastupdated
  end

  
  ############################################################################
  #                             Private Methods                              #
  ############################################################################
  private

  # Function used to fill @_decks table
  def setAllCards()
    @cards = []
    # cUrl inits
    c = Curl::Easy.new()
    c.follow_location = true
    c.url = @url
    c.http_get
    # megic nokiri html parser
    parsed = Nokogiri::HTML(c.body_str)
    # getting each cards name via css selectas
    card = parsed.css(".t-deck-details-card-list tbody .col-name a")
    for i in 0..card.size-1
      @cards.push(card[i].text.strip)
    end
    # now our cards name are stored in a tab inside the deck
  end
  
end
