require 'nokogiri'

class Cards
  # Private properties
  _Cards = Array.new
  
  public
  # public methods
  def initialize()
    # cUrl inits
    c = Curl::Easy.new()
    c.follow_location = true

    # gotta parse every page
    page = 1
    nxt = true
    while (nxt)
      c.url = "http://www.hearthpwn.com/cards?display=1&filter-premium=1&page=" + page.to_s
      c.http_get
      # megic nokiri html parser
      parsed = Nokogiri::HTML(c.body_str)
      # getting each cards infos
      card = parsed.css(".col-name a")

      # storing cards infos like this :
      # id, name, rarity, type, class, cost, attack, health
      for i in 1..card.size-1
        printf "%-20.20s %-5.5s\n",
          card[i].text,
          card[i]['data-id']
      end
      # getting each cards id


      # Checking if next page button is present,
      # If not, then that's the last page,
      # we can leave da loop
      nxt = false
      parsed.css(".j-listing-pagination .b-pagination-item a").each do |pagesbtn|
        if pagesbtn.text == "Next"
          nxt = true
        end
      end
      page = page + 1 # moving to next page
    end
  end
  
  
  private
  # private methods
  
end
