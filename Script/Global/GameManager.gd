extends Node
class_name GameManager

enum gameState {
	Menu,
	Playing,
	Preparing,
	Paused,
	GameOver
}

var currentState : gameState = gameState.Menu

var EnemySpawningHandler
var WaveHandler
var DeckHandler


# UI
var DeckUI
var DiscardPileUI
var UIManager

var BaseManager 

@export var map : String = "CorruptedWasteland"

@export var startingCardDrawnPerShuffle : int

@export var powerRegenRate : float = 1.0

@export var startGameWithPrepare : bool = true

@export var startingPower : int = 0

@export var defaultBaseMaxHP : float = 300

func _ready() -> void:
	initiallize()

func initiallize() -> void:
	EnemySpawningHandler = get_tree().get_first_node_in_group("EnemySpawnHandler")
	WaveHandler = get_tree().get_first_node_in_group("WaveSystem")
	DeckHandler = get_tree().get_first_node_in_group("DeckHandler")
	DiscardPileUI = get_tree().get_first_node_in_group("DiscardPileUI")
	BaseManager = get_tree().get_first_node_in_group("BaseManager")
	UIManager = get_tree().get_first_node_in_group("UIManager")

	#UI
	DeckUI = get_tree().get_first_node_in_group("DeckUI")
	
	Global.cardsDrawnOnShuffle = startingCardDrawnPerShuffle

	Global.Victory.connect(on_victory)
	
	#Global.PowerRegenTimer.wait_time = powerRegenRate
	print("System Ready!")
	gameStart()

func gameStart() -> void:
	
	currentState = gameState.Playing
	Global.Power = startingPower
	# If we want a preparation period before the first wave, mark the global flag
	# before starting wave/spawn systems so they can initialize but will not begin
	# spawning while `Global.isWaveBreak` is true.
	if startGameWithPrepare:
		Global.isWaveBreak = true

	if EnemySpawningHandler:
		EnemySpawningHandler.start(map)

	if WaveHandler:
		WaveHandler.start()
	
	if DeckHandler:
		DeckHandler.initialize()
		DeckHandler.startingDeckSetup()
		DeckHandler.createHands(Global.cardsDrawnOnShuffle) #Create 5 cards
	
	if DiscardPileUI:
		DiscardPileUI.initialize()
	
	if DeckUI:
		DeckUI.initialize()
	
	if BaseManager:
		BaseManager.initialize(defaultBaseMaxHP)
	
	if startGameWithPrepare:
		# Defer emitting WaveEnd so other nodes have time to connect in their _ready()
		# This will trigger the preparation UI/flow (via WaveEndHandler) while
		# the wave/spawn systems are initialized but paused by Global.isWaveBreak.
		Global.call_deferred("emit_signal", "WaveEnd")

	print("Game Ready!")


var defeatScreen : PackedScene = preload("res://Scenes/UI/GeneralUI/DefeatScreen.tscn")
var winScreen : PackedScene = preload("res://Scenes/UI/GeneralUI/WinScreen.tscn")	
	
func defeated(): #what happened when you lose (aka base losing all HP)

	currentState = gameState.GameOver

	WaveHandler.defeat()
	Global.isWaveBreak = true


	var defeatScreenInst = defeatScreen.instantiate()

	UIManager.addChildToLayer(defeatScreenInst, "overwrite")

func on_victory() -> void:
	if currentState == gameState.GameOver:
		return

	currentState = gameState.GameOver
	Global.isWaveBreak = true

	WaveHandler.defeat()

	var winScreenInst = winScreen.instantiate()
	UIManager.addChildToLayer(winScreenInst, "overwrite")

	

func restart():
	get_tree().reload_current_scene()
	