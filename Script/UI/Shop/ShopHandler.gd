extends Control

@export var toolShopItems : Array[Resource]
@export var cardShopItems : Array[Resource]

@export var toolShopSize : int
@export var cardShopSize : int


@export_group("HideUIS")
@export var hideHand: bool = true
var handUI


var deckHandler
var cards

var toolHandler
var tools

var ToolShopUI : GridContainer
var CardShopUI : HBoxContainer

signal shopClosed()

@export var priceForToolRarity = {
	"Common": 20,
	"Rare": 50,
	"Legendary": 100
}

@export var toolRarityChances = {
	"Common": 0.7,
	"Rare": 0.25,
	"Legendary": 0.05
}

var InteractToolBase : PackedScene = preload("res://Scenes/UI/Tools/ToolBase.tscn")
var InteractCardBase : PackedScene = preload("res://Scenes/UI/Cards/InteractableCard.tscn")

func _ready() -> void:
	initialize()

func initialize() -> void:

	ToolShopUI = $MarginContainer/VBoxContainer/Panel/MarginContainer/ShopItems/ToolsShop
	CardShopUI = $MarginContainer/VBoxContainer/Panel/MarginContainer/ShopItems/CardShopMargin/CardShop

	deckHandler = get_tree().get_first_node_in_group("DeckHandler")

	if deckHandler == null:
		print("DeckHandler not found. Disabling shop.")
		return

	cards = deckHandler.cards

	toolHandler = get_tree().get_first_node_in_group("ToolHandler")

	if toolHandler == null:
		print("ToolHandler not found. Disabling shop.")
		return

	tools = toolHandler.tools
	#print("Yo: " + str(tools.size()))
	setupToolPrice()
	setupToolShop()

	hideCertainUI()

	print("Tools in shop: " + str(toolShopItems.size()))
	for Tool in toolShopItems: #test
		print(Tool.toolName)


# TOOL SHOPPPPPASDASD


func setupToolShop() -> void:
	toolShopItems.clear()

	for idx in toolShopSize:
		var rarity = getRandomToolRarity()
		var Tool = getRandomToolByRarity(rarity)
		if Tool != null:
			addToolToShop(Tool)

func getRandomToolRarity() -> String:
	var roll = randf()
	var cumulative = 0.0
	for rarity in toolRarityChances.keys():
		cumulative += float(toolRarityChances[rarity])
		if roll < cumulative:
			return rarity
	return toolRarityChances.keys()[toolRarityChances.size() - 1]

func getRandomToolByRarity(rarity: String) -> ToolData:
	var candidates : Array = []
	for tool in tools.values():
		if tool.toolRarity == rarity:
			candidates.append(tool)

	if candidates.is_empty():
		candidates = tools.values()

	if candidates.is_empty():
		return null

	return candidates[randi() % candidates.size()]

func setupToolPrice() -> void:
	var currentWave = max(1, Global.CurrentWave)
	for rarity in priceForToolRarity.keys():
		priceForToolRarity[rarity] = int(priceForToolRarity[rarity] * pow(1.25, currentWave - 1)) # Example: Increase price by 25% each wave after the first one


func addToolToShop(Tool: ToolData) -> void:
	toolShopItems.append(Tool)

	var ToolUI = InteractToolBase.instantiate()
	ToolUI.toolData = Tool
	ToolUI.Interactable = true
	ToolShopUI.add_child(ToolUI)
	ToolUI.toolSelected.connect(onToolSelected)


	ToolUI.currentShopPrice = priceForToolRarity.get(Tool.toolRarity, priceForToolRarity["Common"]) # Default to Common price if rarity not found
	ToolUI.shopToolID = toolShopItems.size() - 1 # Set shop ID based on current size of the shop list

func removeToolFromShop(shopID : int, toolUI):
	if shopID >= 0:
		toolShopItems.remove_at(shopID)
		toolUI.queue_free()
	else:
		if toolUI:
			toolUI.queue_free()
		print("Invalid shop ID: ", shopID)


func onToolSelected(tool):
	
	if Global.payPower(tool.currentShopPrice):
		toolHandler.addTool(tool.toolData)
		print("Purchased tool: " + tool.toolData.toolName)
		removeToolFromShop(tool.shopToolID, tool)


# CARD SHOPPPPP


func setupCardShop() -> void:
	cardShopItems.clear()

	var availableCards = cards.duplicate()
	

	for idx in cardShopSize:
		if availableCards.size() == 0:
			break

		var card = availableCards.values()[randi() % availableCards.size()]
		addCardToShop(card)


func addCardToShop(card: CardData) -> void:
	cardShopItems.append(card)

	var CardUI = InteractCardBase.instantiate()
	var cardBaseInst = CardUI.find_child("Card")
	cardBaseInst.cardInfo = card.stats
	CardUI.cardData = card

	# construction in progress. ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
	# temporary reminder: fix the card system first so everything is inside one script.
	# have to study SAT now so fix it later. 





func hideCertainUI():
	if hideHand:
		handUI = get_tree().get_first_node_in_group("HUD")
		if handUI != null:
			handUI.visible = false

func showbackUI():

	if hideHand and handUI != null:
		handUI.visible = true

func _on_exit_button_pressed() -> void:
	emit_signal("shopClosed")
	showbackUI()
	queue_free()
