extends Control

var deckHandler 
#var interactCard = preload("res://Scenes/UI/Cards/InteractableCard.tscn")
var baseCard = preload("res://Scenes/UI/Cards/CardBase.tscn")
var towerPlacement = preload("res://Scenes/Tower/TowerPlacement.tscn")

var currentHandSize : int

@export var startShuffleCost : int
var shuffleCost

var waveEndHandler : Node

func _ready() -> void:
	shuffleCost = startShuffleCost
	currentHandSize = 0
	deckHandler = get_tree().get_first_node_in_group("DeckHandler")

	if deckHandler == null:
		print("cant find deckhandler")
		return

	deckHandler.PushHands.connect(pushCard)

	waveEndHandler = get_tree().get_first_node_in_group("WaveEndHandler")

	if waveEndHandler == null:
		print("cant find wave handler")
		return

	Global.WaveEnd.connect(startPreparationPeriod)
	Global.NextWave.connect(nextWave)


func pushCard(card : CardData):
	var cardInst = baseCard.instantiate()
	cardInst.interactable = true
	#cardInst.cardInfo = card.stats
	cardInst.cardData = card
	add_child(cardInst)
	cardInst.cardSelected.connect(onCardSelected)
	currentHandSize += 1

func onCardSelected(cardData : CardData , cardNode):
	var towerPlacementInstance = towerPlacement.instantiate()
	towerPlacementInstance.TowerStat = cardData.stats
	get_tree().current_scene.add_child(towerPlacementInstance)
	
	towerPlacementInstance.placementFinished.connect(onPlacementFinished.bind(cardData , cardNode))

func onPlacementFinished(success : bool , cardData : CardData , cardNode):

	if cardNode.isSelected != null:
		cardNode.isSelected = false

	if success:
		cardPop(cardData , cardNode)
	else:
		pass


func cardPop(cardData : CardData , cardNode):
	cardNode.queue_free()
	deckHandler.cardPopfromHand(cardData)
	currentHandSize -= 1
	

func refresh(): #Refresh the current hand
	for card in get_children(): 
		cardPop(card.cardData , card) #Delete every cards in current hand
	deckHandler.createHands(Global.cardsDrawnOnShuffle)

func _on_shuffle_pressed() -> void:
	if Global.payPower(shuffleCost):
		refresh()



func startPreparationPeriod():
	refresh()

func nextWave():
	for card in get_children(): 
		cardPop(card.cardData , card) #i think that i should make a pop all card function but maybe later