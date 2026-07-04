extends Node

# Collections must be initialized to avoid null issues
var deck : Array[CardData] = []
var discardPile : Array[CardData] = []

# Cards lookup
var cards : Dictionary = {}

# UID generator
var curUIDgen : int = 0
# STARTING 

##Signals
#Detect changes in the hand
signal PushHands(card : CardData)
signal PopHands(card : CardData, idx : int)

signal NewCardDeck(card : CardData)
signal PopCardDeck(card : CardData)

signal NewDiscard(card : CardData)
signal PopDiscard(card : CardData)

func initialize():
	deck = []
	discardPile = []
	cards = {}
	curUIDgen = 0
	load_cards()
	#startingDeckSetup()
	#showCurrentDeck()

func genID() -> String:
	curUIDgen += 1
	return str(curUIDgen)


@export var loadingCards : Array[TowerData]

func load_cards():
	cards.clear()

	for towerData in loadingCards:
		cards[towerData.id] = towerData
	

	print("Cards loaded: ", cards)

func createCardData(towerStat : TowerData) -> CardData:
	var card = CardData.new()
	card.stats = towerStat
	card.UID = genID()
	return card

func startingDeckSetup():
	# Create starting cards
	for i in range(5):
		newCard(cards["normalpawn"])

	for i in range(4):
		newCard(cards["normalbishop"])
	
	#print("works fine")


func newCard(towerStat : TowerData):
	if not towerStat == null:
		var card = createCardData(towerStat)
		deck.append(card)
		print("New Card: " + str(curUIDgen))
		emit_signal("NewCardDeck", card)

func showCurrentDeck(): #Show current deck, test only
	print("Current Deck:")
	for card in deck:
		print(card.stats.Name)

func showCurrentDiscardPile(): #Show current discard pile, test only
	print("Current Discard Pile:")
	#for card in discardPile:
	#	print(card.stats.Name)

func createHands(amount : int):
	if deck.size() < amount: 
		reShuffle()
		print("shuffled discard pile!!!!!!!!!!!!!")
		if deck.size() < amount: #Check if even after shuffled, there is enough card to draw X card or not.
			amount = deck.size()
	for idx in range(amount):
		#Kind of messy here but you just pick a random card out of the deck
		var ranIdx = randi_range(0,deck.size()-1)
		var card = deck[ranIdx]
		cardPopfromDeck(card, ranIdx) #Remove the card in Deck then transfer it to the hands 
		emit_signal("PushHands", card)


func reShuffle(): #Shuffle the discard pile into the deck
	while discardPile.size() > 0:
		transferDiscardPileToDeck(discardPile.back())
	
func transferDiscardPileToDeck(card : CardData):
	print("T R A N S F E R E D")
	discardPile.pop_back()
	deck.append(card)
	emit_signal("PopDiscard", card)
	print("pop discard")
	emit_signal("NewCardDeck", card)

func cardPopfromHand(card : CardData): 
	discardPile.append(card) #Push the card to the discard pile
	emit_signal("NewDiscard", card)
	
			
func cardPopfromDeck(cardData : CardData, idx : int):
	
	if idx != -1:
		deck.remove_at(idx)
	else:
		var cardIdx = deck.find(cardData)
		if cardIdx != -1:
			deck.remove_at(cardIdx)
	
	print("pop card: " + str(cardData) + " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	emit_signal("PopCardDeck", cardData)
			
			
			
			
