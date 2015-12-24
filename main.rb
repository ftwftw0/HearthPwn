require 'curb'
# This line includes all files in srcs folder
Dir[File.dirname(__FILE__) + '/srcs/*.rb'].each {|file| require file }

##################################### MAIN #########################################


# Gotta find card list that i dont have
mycards = findCardsPresent()
# Generature filtered url to get Decks i can build with my actual cards.
filteredUrl = ""
mycards.each do |card|
  printf "%-15.15s %s \n", card['name'], card['id']
end

findBestDecks()

