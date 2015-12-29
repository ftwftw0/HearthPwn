require 'curb'
require 'nokogiri'

#
# This function find the missing cards you need the most.
# mycards is a table of card's names. nbofdeckstocheck is the number of
# decks you want to count the cards you miss in, starting from monthly top deck.
#
def findMostNeededCards(mycards, nbofdeckstocheck = 100)
  decks = []
  # cUrl inits
  c = Curl::Easy.new()
  c.follow_location = true

  #
  # Start by parsing the monthly top decks page.
  # Pages will be browsed one by one in da following loop until the
  # 'Next' # button is present, or the number of checked decks exceeds.
  #
  page = 1
  nextbtn = true
  nbofdeckschecked = 0
  missingcards = []
  while (nextbtn && nbofdeckstocheck > nbofdeckschecked)
    c.url = "http://www.hearthpwn.com/decks?filter-build=26&filter-deck-tag=4&filter-deck-type-val=8&filter-deck-type-op=4&page=" + page.to_s + "&sort=-rating"
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
    # creating decks via infos
    for i in (0..deckname.size-1)
      if  nbofdeckstocheck <= nbofdeckschecked
        break
      end
      deck = Deck.new(deckname[i].text.strip,
                      classname[i].text.strip,
                      type[i].text.strip,
                      rating[i].text.strip,
                      cost[i].text.strip.to_i,
                        lastupdated[i].text.strip,
                      "www.hearthpwn.com" + deckname[i]['href'])
      printf "Checking cards for \"%s\" deck. Rating %s \n", deck.name, deck.rating
      if (deck.cards.size < 30)
        printf "This deck is fucked. It has less than 30 cards.\n"
      else
        ret = countMissingCards(deck.cards, mycards, missingcards)
        printf "You need %i more card(s)...\n", ret
      end

      # Checking if next page button is present,
      # If not, then that's the last page, we can leave loop.
      nextbtn = false
      parsed.css(".j-listing-pagination .b-pagination-item a").each do |pagesbtn|
        if pagesbtn.text == "Next"
          nextbtn = true
        end
      end
      nbofdeckschecked += 1
    end
    page += 1
  end
  return missingcards.sort! {|left,right| left['times'] <=> right['times']}
end

def countMissingCards(deckcardnames, mycards, missingcards)
  missing = 0
  deckcardnames.each do |deckcardname|
    # Checking if deckcard is present in mycards
    if !cardnameInArray(mycards, deckcardname)
      # Checking if deckcard is already noted in missingcards
      alreadynoted = false
      missingcards.each do |onemissingcard|
        # If so, add a time to missingcard[index]['times']
        if onemissingcard['name'] == deckcardname
          alreadynoted = true
          onemissingcard['times'] += 1
          missing += 1
          break
        end
      end
      # Otherwise, just add the following hash to the missingcards table :
      # {'name' => missingcardname, 'times' => 1}
      if alreadynoted == false
        missingcards.push({'name' => deckcardname, 'times' => 1})
      end
    end
  end
  return missing
end


