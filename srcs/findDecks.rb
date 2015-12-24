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
  deckname = parsed.css("tbody .col-name span a")
  classname = parsed.css("tbody .col-class")
  type = parsed.css("tbody .col-deck-type")
  rating = parsed.css("tbody .col-ratings")
  cost = parsed.css("tbody .col-dust-cost")
  lastupdated = parsed.css("tbody .col-updated .standard-date")
  for i in (0..deckname.size-1)
    decks.push(Deck.new(deckname[i].text.strip,
                        classname[i].text.strip,
                        type[i].text.strip,
                        rating[i].text.strip,
                        cost[i].text.strip.to_i,
                        lastupdated[i].text.strip,
                        "www.hearthpwn.com" + deckname[i]['href']))
  end
  return decks
end
