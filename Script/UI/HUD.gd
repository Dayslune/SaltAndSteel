extends Control

var deckHandler 
#var interactCard = preload("res://Scenes/UI/Cards/InteractableCard.tscn")
var baseCard = preload("res://Scenes/UI/Cards/CardBase.tscn")
var towerPlacement = preload("res://Scenes/Tower/TowerPlacement.tscn")

var currentHandSize : int

var waveEndHandler : Node

@onready var hand = $VBoxContainer/HBoxContainer2/Hand
@onready var refreshButton = $VBoxContainer/HBoxContainer2/Refresh

@onready var deckRelatedContainer = $VBoxContainer/HBoxContainer2

@onready var importantStatsContainer = $VBoxContainer #contain Base HP bar and cards related stuffs.

func _ready() -> void:

	refreshButton.text = "Shuffle \n(" + str(hand.startShuffleCost) + " Power)"

	waveEndHandler = get_tree().get_first_node_in_group("WaveEndHandler")
	deckHandler = get_tree().get_first_node_in_group("DeckHandler")

	if waveEndHandler == null:
		print("cant find wave handler")
		return

	Global.WaveEnd.connect(startPreparationPeriod)
	Global.NextWave.connect(nextWave)

func _on_shuffle_pressed() -> void:
	if Global.payPower(hand.shuffleCost):
		hand.refresh()
		pass



var deckUI 

func _on_show_deck_pressed() -> void:
	deckHandler.showCurrentDeck()

	deckUI = get_tree().get_first_node_in_group("DeckUI")
	if not deckUI:
		return 
	
	deckUI.showDeck()

var discardPileUI

func _on_show_discard_pile_pressed() -> void:
	deckHandler.showCurrentDiscardPile()

	discardPileUI = get_tree().get_first_node_in_group("DiscardPileUI")

	if not discardPileUI:
		return 
	
	discardPileUI.showDiscardPile()


@onready var startWaveButton = $StartWaveButton


func _on_start_wave_button_pressed() -> void:
	
	if waveEndHandler:
		waveEndHandler.nextWave()
	else:
		print("wavehandler not existed")
		return 

func startPreparationPeriod():
	startWaveButton.visible = true 
	hand.visible = true
	refreshButton.visible = true

func nextWave():
	startWaveButton.visible = false
	hand.visible = false
	refreshButton.visible = false


func showBaseHpBar( bossBar : Node ):
	importantStatsContainer.add_child(bossBar)
	importantStatsContainer.move_child(bossBar, deckRelatedContainer.get_index() - 2) #move the bossBar in front of the deckrelated container
