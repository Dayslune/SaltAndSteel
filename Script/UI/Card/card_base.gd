extends Control
class_name CardBase

var cardInfo : TowerData 

#Basically, if the card is not in the deck yet then it wouldn't be assigned with an ID. 
#CardData is only used when it's in the deck and has its own UID. The reason why I implement 
#this is because i might add upgrades to cards in the future, which requires each card to has
#their own data. 

var cardData : CardData #If cardData is null use cardInfo
@export var interactable : bool = false

@onready var Art = $Art
@onready var Title = $Title
@onready var Cost = $Cost
@onready var Damage = $Stats/VBoxContainer/Damage
@onready var ASP = $Stats/VBoxContainer/ASP
@onready var ARange = $Stats/VBoxContainer/Range
@onready var Type = $Stats/VBoxContainer/Type

signal cardSelected(card, cardNode)

#var tower = preload("res://Scenes/Tower/TowerPlacement.tscn")


func _ready():

	#testCardData()


	var button = $Button

	if not interactable:
		button.visible = false
	else:
		button.visible = true

	var towerInfo 
	if not cardData:
		towerInfo = cardInfo 
	else:
		towerInfo = cardData.stats
	
	if not towerInfo:
		return 
	
	Title.text = towerInfo.Name 
	Art.texture = towerInfo.TowerArt
	Cost.text = "Cost: " + str(towerInfo.Cost)
	Damage.text = "Damage: " + str(towerInfo.Damage)
	ASP.text =  "ASP: " + str(towerInfo.AttackCooldown) + "s"
	ARange.text = "Range: " + str(towerInfo.AttackRange)
	Type.text = "Type: " + str(towerInfo.Type)
	

func testCardData():
	var pawntower = load("res://Resources/Towers/NormalPawn.tres")
	var testcardData = CardData.new()
	testcardData.stats = pawntower
	testcardData.UID = "test123"
	cardData = testcardData

func _on_button_pressed() -> void:
	#print(cardData)
	if cardData:	
		emit_signal("cardSelected", cardData, self)
	else:
		emit_signal("cardSelected", cardInfo, self)
	
