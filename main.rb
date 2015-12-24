require 'curb'
# This line includes all files in srcs folder
Dir[File.dirname(__FILE__) + '/srcs/*.rb'].each {|file| require file }

##################################### MAIN #########################################


# Gotta find card list that i have in the entered file
mycards = findCardsPresent('cardsfile/myCards.txt')

mycards.each do |card|
  printf "%-15.15s %s \n", card['name'], card['id']
end



bestDecks = findBestDecks()
for i in (0..10)
  bestDecks[i].print
end
