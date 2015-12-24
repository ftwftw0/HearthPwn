require 'curb'
require 'nokogiri'

def findBestDecksFromCardsfile()
  decks = []
  # cUrl inits
  c = Curl::Easy.new()
  c.follow_location = true

  # gotta parse monthly top decks page                                        
  c.url = "http://www.hearthpwn.com/decks?filter-build=26&filter-deck-tag=4&filter-deck-type-val=8&filter-deck-type-op=4&sort=-rating"
  c.http_get
  # magic nokiri html parser                                                  
  parsed = Nokogiri::HTML(c.body_str)
  # getting each cards infos via css selectas
  deck = parsed.css("tbody .col-name span a")
  rating = parsed.css("tbody .col-ratings")
  cost = parsed.css("tbody .col-dust-cost")
  for i in (0..10)
    printf "%-20.20s Upvotes:%-5i Cost:%-6.6s \n", deck[i].text.chomp, rating[i].text.to_i, cost[i].text.chomp
  end
end
