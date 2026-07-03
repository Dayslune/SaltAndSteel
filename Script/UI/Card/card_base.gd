extends Control
class_name CardBase

var cardInfo : TowerData 

#Basically, if the card is not in the deck yet then it wouldn't be assigned with an ID. 
#CardData is only used when it's in the deck and has its own UID. The reason why I implement 
#this is because i might add upgrades to cards in the future, which requires each card to has
#their own data. 

var cardData : CardData #If cardData is null use cardInfo
@export var interactable : bool = false

#@onready var Art = $Art
#@onready var Title = $Title
#@onready var Cost = $Cost

var towerInfo : TowerData

signal cardSelected(card, cardNode)

#var tower = preload("res://Scenes/Tower/TowerPlacement.tscn")


func _ready():

	#testCardData()


	var button = $Button

	if not interactable:
		button.visible = false
	else:
		button.visible = true

	if not cardData:
		towerInfo = cardInfo 
	else:
		towerInfo = cardData.stats
	
	if not towerInfo:
		return 
	
	$Title/Name.text = towerInfo.Name

	#$Title._update_size()

	setupStats()
	

var statBox : PackedScene = preload("res://Scenes/UI/Cards/CardParts/Statbox.tscn")

func setupStats() -> void:
	
	var statContainer = $Stats

	for stat in towerInfo.get_property_list():
		if stat.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and stat.name not in ["Name", "id", "TowerTexture", "TowerArt", "Type", "Cost", "Rarity", "PlacementRange"]:
			var statValue = towerInfo.get(stat.name)
			if statValue == 0:
				continue

			if statValue is float and stat.name in ["AttackRange", "PlacementRange", "Damage"]:
				statValue = int(statValue) # convert to int so it look better
			

			var statBoxInstance = statBox.instantiate()
			statContainer.add_child(statBoxInstance)
			
			var icon = load("res://Asset/Icons/Stats/" + stat.name + ".png")
			var statInfo = str(statValue)

			if stat.name == "AttackCooldown":
				statInfo += "s"

			statBoxInstance.setup(icon, statInfo)

			statContainer.size.x = statContainer.get_combined_minimum_size().x + (statContainer.get_combined_minimum_size().x - 70) 

			if statContainer.get_children().size() > 3:
				statContainer.position.y -= statBoxInstance.get_combined_minimum_size().y - statContainer.get_theme_constant("separation")

			# ^ this makes it so that the new statboxes wont extended out of the card, it will move up. i cant find any thing that makes this process automatic so i js have to implement all these hassles.	

			statBoxInstance.z_index = 1
	

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
	
