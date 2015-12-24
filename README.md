This little library has been made to improve the HearthPwn search system, adding functionalities, etc.

All you need is to include all rb files from the srcs folder by adding, for example, the following line :
Dir[File.dirname(__FILE__) + '/srcs/*.rb'].each {|file| require file }

Here the cool things begin.

##################################################################


The following classes/functions will then be added to your project :


##################################################################


##################################################################
                          Classes
##################################################################



------------------------------------------------------------------
                            Cards
This class is a singleton. It contains every hearthstone cards.
In fact, it contains a table of hashs each representing a card. This hash is formated like this :
{ id, name, rarity, type, class, cost, attack, health }
To access the first (which does not mean 'first' at all. i mean cards are stored in a random order, but they just all are stored) card's cost, do the following :
Cards.instance.cards[0]['cost']
------------------------------------------------------------------

- cards
  Returns the card's array

- getIdByName(name)
  Find the HearthPwn id of a card via it's name


------------------------------------------------------------------
                            Deck
This class represents a deck. It contains following informations : name, ...
------------------------------------------------------------------

