extends Control

var deckHandler
var deck

var container

var cardBase = preload("res://Scenes/UI/Cards/CardBase.tscn")

func _ready() -> void:

	deckHandler = get_tree().get_first_node_in_group("DeckHandler")
	if not deckHandler:
		print("cant find deckhandler")
		return 
	
	#deckHandler.initialize()
	deck = deckHandler.deck
	deckHandler.NewCardDeck.connect(newCard)
	deckHandler.PopCardDeck.connect(popDeck)

	container = $VBoxContainer/ScrollContainer/GridContainer

	if not container:
		print("cant find gridcontainer")
	

	

	#initialize()

func initialize():
	pass
	#for card in deck:
	#	newCard(card)


func createCardBase(cardData : CardData):
	var card = cardBase.instantiate()
	card.interactable = false
	card.cardData = cardData
	return card


func newCard(cardData : CardData):
	#print(cardData.UID)
	#print("New card : ", cardData)
	container.add_child(createCardBase(cardData))


func popDeck(cardData : CardData):
	for card in container.get_children():
		if card is CardBase:
			if card.cardData == cardData:
				#print("ok")
				card.queue_free()


func closeDeck():
	visible = false

func showDeck():
	visible = true


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_close_pressed() -> void:
	closeDeck()
