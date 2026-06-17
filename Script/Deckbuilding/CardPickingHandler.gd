# If ur wondering where this scene is called, it's instantiated by the WaveEndHandler.gd in the WaveSystem folder.
# i spend 15 minutes trying to find where i called it
# 🥀



extends Control

@export var cardShown : int = 3

#var interactCardBase := preload("res://Scenes/UI/Cards/InteractableCard.tscn")

var cardBase := preload("res://Scenes/UI/Cards/CardBase.tscn")

var deckHandler 
var cardsList : Dictionary

var container : HBoxContainer

signal cardPicked()

func _ready() -> void:
	initialize()

func initialize():
	deckHandler = get_tree().get_first_node_in_group("DeckHandler")
	cardsList = deckHandler.cards
	print(cardsList)
	container = $VBoxContainer/HBoxContainer
	createChoices(cardShown)


func createChoices(_amount : int):
	print("ok")
	for i in _amount:
		print(i)
		var cardTemplate = takeRandom()
		print(cardTemplate)
		if cardTemplate != null:
			var cardInst = cardBase.instantiate()
			cardInst.interactable = true
			cardInst.cardInfo = cardTemplate
			container.add_child(cardInst)
			cardInst.cardSelected.connect(onCardSelected)


func takeRandom():
	if cardsList.is_empty():
		return null
	
	var values = cardsList.values()
	return values[randi_range(0, values.size() - 1)]


func onCardSelected(cardTemplate, cardNode):
	if cardTemplate == null:
		return
	deckHandler.newCard(cardTemplate)
	cardNode.queue_free()
	emit_signal("cardPicked")
	queue_free()
