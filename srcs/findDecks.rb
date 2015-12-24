def findBestDecks()
  decks = []
  # cUrl inits
  c = Curl::Easy.new()
  c.follow_location = true

  # gotta parse monthly top decks page                   
  c.url = "http://www.hearthpwn.com/decks?filter-build=26&filter-deck-tag=4&filter-deck-type-val=8&filter-deck-type-op=4&sort=-rating"
  c.http_get
  # megic nokiri html parser
  parsed = Nokogiri::HTML(c.body_str)
  # getting each cards infos via css selectas
  deck = parsed.css("tbody .col-name span a")
  rating = parsed.css("tbody .col-ratings")
  cost = parsed.css("tbody .col-dust-cost")
  for i in (0..10)
    printf "%-20.20s Upvotes:%-5i Cost:%-6.6s \n", deck[i].text.chomp, rating[i].text.to_i, cost[i].text.chomp
  end
end

def cardIsPresent(cardNames, card)
  cardNames.each do |name|
    if name == card['name']
      return true
    end
  end
  return false
end

def findCardsPresent()
  # That's the file where each line's the name of cards i have    
  mycardsfile = File.open('cardsfile/myCards.txt', 'r')
  # That's the table of all cards i have              
  mycards = []
  mycardsfile.each_line do |cardname|
    id = Cards.instance.getIdByName(cardname.chomp)
    if (id)
      mycards.push(cardname.chomp)
      #printf "%-15.15s %s \n", cardname.chomp, c.getIdByName(cardname.chomp)
    end
  end
  # Find decks without cards i dont have
  possessedcards = Cards.instance.cards.select { |card| cardIsPresent(mycards, card) }
end
