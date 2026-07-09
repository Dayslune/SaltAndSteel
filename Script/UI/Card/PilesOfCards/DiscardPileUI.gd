extends Control

var deckHandler
var discardPile

var container

var cardBase = preload("res://Scenes/UI/Cards/CardBase.tscn")

func _ready() -> void:

	deckHandler = get_tree().get_first_node_in_group("DeckHandler")
	if not deckHandler:
		print("cant find deckhandler")
		return 
	
	#deckHandler.initialize()
	discardPile = deckHandler.discardPile
	deckHandler.NewDiscard.connect(newDisCard)
	deckHandler.PopDiscard.connect(popDisCard)

	container = $VBoxContainer/ScrollContainer/GridContainer

	if not container:
		print("cant find gridcontainer")
	

	

	#initialize()

func initialize():
	
	for card in discardPile:
		newDisCard(card)


func createCardBase(cardData : CardData):
	var card = cardBase.instantiate()
	#container.add_child(card)
	#await card.ready
	#print("ok")
	card.interactable = false
	card.cardData = cardData
	container.add_child(card)
	#await card.ready
	card.setupArt("DISCARD PILE: ")


func newDisCard(cardData : CardData):
	createCardBase(cardData)

func popDisCard(cardData : CardData):
	print("pop card!")
	for card in container.get_children():
		if card is CardBase:
			if card.cardData == cardData:
				print("pop card!")
				card.queue_free()


func closeDiscardPile():
	visible = false

func showDiscardPile():
	visible = true




func _on_close_pressed() -> void:
	closeDiscardPile()
