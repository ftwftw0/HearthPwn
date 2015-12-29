require 'curb'
require 'io/console'
# This line includes all files in srcs folder
Dir[File.dirname(__FILE__) + '/srcs/*.rb'].each {|file| require file }

##################################### MAIN #########################################

def usage
  puts <<MESSAGE

Here's how to use this crazy program. Take care, it sometimes bites.
You can analyse your deck and get some statistics you can't get on the Hearthstone.
You may need to do some things before doing that, like saving your cards in a deckfile.
A deckfile is only a text file containing the cards you have. All of them, including basic cards.

Yeah, it rocks, there are some commands :

- To analyse X (X here is a number) monthly top decks until it finds one fitting your cards perfectly type :
> ruby main.rb PATH/TO/YOUR/DECKFILE BESTMONTHLYDECK

- To analyse X monthly top decks to tell you which cards you need the most to make these decks, type :
> ruby main.rb PATH/TO/YOUR/DECKFILE CARDSINEEDTHEMOST

More features are coming. Until then, have fun broh'.
MESSAGE
  exit (-1)
end

usage() if (ARGV.empty?)
command = ARGV[0]
deckfile = ARGV[1]
if (File.file?(deckfile) == false)
  puts "This is not a valid deckfile."
  exit
end

# Gotta find card list that i have in the entered file
mycards = findCardsPresent('cardsfile/myCards.txt')

mycards.each do |card|
  printf "%-15.15s %s \n", card['name'], card['id']
end

#suitableDeck = findBestsSuitableDecks(mycards)
mostNeededCards = findMostNeededCards(mycards)

mostNeededCards.each do |card|
  printf "You need this card : %-20.20s  - Priority %i\n", card['name'], card['times']
end
