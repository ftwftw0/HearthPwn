def findCardsPresent(path)
  # That's the file where each line's the name of cards i have
  mycardsfile = File.open(path, 'r')
  # That's the table of all cards i have
  mycards = []
  mycardsfile.each_line do |cardname|
    id = Cards.instance.getIdByName(cardname.strip)
    if (id)
      mycards.push(cardname.strip)
      #printf "%-15.15s %s \n", cardname.strip, c.getIdByName(cardname.strip)
    end
  end
  # Find decks without cards i dont have
  possessedcards = Cards.instance.cards.select { |card| cardIsPresent(mycards, card) }
end

def cardIsPresent(cardsTab, card)
  cardsTab.each do |onecard|
    if onecard == card['name']
      return true
    end
  end
  return false
end
