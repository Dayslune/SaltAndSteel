extends Control
class_name CardBase

@export var cardInfo : TowerData 

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
@export var hoverEffect : bool
var visualNode : Control
signal cardSelected(card, cardNode)

#var tower = preload("res://Scenes/Tower/TowerPlacement.tscn")

#kind of messy with the visual thing currently.
var costPanel : Panel
var typePanel : Panel
var art 
func _ready():

	#testCardData()

	costPanel = $Visual/Cost
	typePanel = $Visual/Type
	var button = $Visual/Button
	art = $Visual/Art
	visualNode = $Visual

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
	
	$Visual/Title/Name.text = towerInfo.Name
	
	#$Visual.scale = Vector2(2, 2)

	#$Title._update_size()

	#pivot_offset = size / 2

	costPanel.setCost(str(towerInfo.Cost))
	typePanel.setType(towerInfo)
	setupStats()
	setupArt("READY")

func setupArt(debug : String = ""):
	if art:
		art.visible = false
		art.texture = towerInfo.TowerArt

		await get_tree().process_frame
		await get_tree().process_frame
		#await get_tree().process_frame


		# messi code but works.

		art.pivot_offset = Vector2(75 * towerInfo.TowerArtCanvasMultiplier, 100 * towerInfo.TowerArtCanvasMultiplier )
		art.scale = Vector2(1,1) / towerInfo.TowerArtCanvasMultiplier
		art.visible = true

		print("ART APPLIED")
		print(art.pivot_offset, art.scale)
	else:
		print("ART NODE NOT FOUND")
	
	print("DEBUG FROM: ", debug)

var statBox : PackedScene

func setupStats() -> void:
	
	var statContainer = $Visual/Stats

	statBox = load("res://Scenes/UI/Cards/CardParts/StatBox.tscn")

	for stat in towerInfo.get_property_list():
		if stat.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and stat.name not in ["Name", "id", "TowerTexture", "TowerArt", "Type", "Cost", "Rarity", "PlacementRange", "TowerArtCanvasMultiplier", "shotPointPosition"]:
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

var isSelected : bool = false

func _on_button_pressed() -> void:
	#print(cardData)
	if isSelected:
		return

	isSelected = true
	
	if cardData:	
		emit_signal("cardSelected", cardData, self)
	else:
		emit_signal("cardSelected", cardInfo, self)

	
	

@export var hoverEffectDuration : float = 0.15
@export var hoverEffectScale : float = 1.5

func hoverEffectOn() -> void:

	var visual = $Visual
	var shadow = $Visual/ShadowPanel #shadow wizard money gang


	if hoverEffect:
		z_index = 3
		
		var tween := create_tween()
		tween.tween_property(visual, "scale", Vector2(hoverEffectScale, hoverEffectScale), hoverEffectDuration).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)

		shadow.visible = true
		costPanel.visible = true

func hoverEffectOff() -> void:
	var visual = $Visual
	var shadow = $Visual/ShadowPanel #shadow wizard money gang

	if hoverEffect:
		z_index = 0
		#visual.scale = Vector2(1, 1)

		var tween := create_tween()
		tween.tween_property(visual, "scale", Vector2(1, 1), hoverEffectDuration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		costPanel.visible = false
		shadow.visible = false




func _on_button_mouse_entered() -> void:
	print("mouse entered")
	
	if hoverEffect:
		hoverEffectOn()

func _on_button_mouse_exited() -> void:
	if hoverEffect:
		hoverEffectOff()
