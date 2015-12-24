require 'curb'
require 'nokogiri'

def findBestsSuitableDecks(mycards)
  decks = []
  # cUrl inits
  c = Curl::Easy.new()
  c.follow_location = true

  #
  # Start by parsing the monthly top decks page.
  # Pages will be browsed one by one in da following loop
  # until the 'Next' button is present.
  #
  page = 1
  nextbtn = true
  while (nextbtn)
    c.url = "http://www.hearthpwn.com/decks?filter-build=26&filter-deck-tag=4&filter-deck-type-val=8&filter-deck-type-op=4&sort=-rating&page=" + page.to_s
    c.http_get
    # megic nokiri html parser
    parsed = Nokogiri::HTML(c.body_str)
    # getting each cards infos via css selectas 
    deckname = parsed.css("tbody .col-name span a")
    classname = parsed.css("tbody .col-class")
    type = parsed.css("tbody .col-deck-type")
    rating = parsed.css("tbody .col-ratings")
    cost = parsed.css("tbody .col-dust-cost")
    lastupdated = parsed.css("tbody .col-updated .standard-date")
    for i in (0..deckname.size-1)
      deck = Deck.new(deckname[i].text.strip,
                      classname[i].text.strip,
                      type[i].text.strip,
                      rating[i].text.strip,
                      cost[i].text.strip.to_i,
                        lastupdated[i].text.strip,
                      "www.hearthpwn.com" + deckname[i]['href'])
      printf "Checking cards for \"%s\" deck. Rating %s \n", deck.name, deck.rating
      if (haveAllCards(deck.cards, mycards))
        decks.push(deck)
        printf "#------ Here's a perfect deck for you ! ------#\n"
        deck.print
        printf "... Press Enter to find another suitable deck ! Ctrl-C to quit. ...\n"
        gets
      else
        puts "Not don't have some cards...\n"
      end

      # Checking if next page button is present,
      # If not, then that's the last page, we can leave loop.
      nextbtn = false
      parsed.css(".j-listing-pagination .b-pagination-item a").each do |pagesbtn|
        if pagesbtn.text == "Next"
          nextbtn = true
        end
      end
      page += 1
    end
  end
  return decks
end

def haveAllCards(deckcards, mycards)
  deckcards.each do |deckcard|
    if !cardnameInArray(mycards, deckcard)
      return false
    end
  end
  return true
end

def cardnameInArray(cardsTab, cardname)
  cardsTab.each do |onecard|
    if onecard['name'] == cardname
      return true
    end
  end
  return false
end

