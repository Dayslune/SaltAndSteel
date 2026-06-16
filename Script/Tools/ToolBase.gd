extends Control

@export var ShowDesc : bool = true

var toolDescBox : PackedScene = preload("res://Scenes/UI/Tools/ToolDescription.tscn")
@export var toolData : ToolData
var toolType : String
var toolTexture : TextureRect

@export var Interactable : bool = false
signal toolSelected(tool)
var button: Button

var currentShopPrice : int = -1 #Only used for shop interactions.
var shopToolID : int = -1 #Only used for shop interactions. -1 when not in shop

func _ready() -> void:
	#toolData = load("res://Resources/ToolsResource/test.tres") # Example tool data, replace with actual data as needed
	initialize()

func initialize():
	toolTexture = $TextureRect
	button = $Button
	button.visible = false #hide by default

	if toolData == null:
		return

	if toolData.toolIcon != null:
		toolTexture.texture = toolData.toolIcon

	if toolData is TowerStatModifier:
		toolType = "TowerStatModifier" 
	else:
		toolType = "Unknown" 
	

	#for interactable tools 
	if Interactable:
		button.visible = true
	


func _on_mouse_entered() -> void:
	#print("Mouse entered!")
	if ShowDesc == false:
		return
	match toolType:
		"TowerStatModifier":
			showDesc_TowerStatModifier()
		_:
			print("no desc.")
	



func _on_mouse_exited() -> void:
	var descInstance = get_node("ToolDescription")
	if descInstance != null:
		descInstance.queue_free()

func showDesc_TowerStatModifier():
	var descInstance = toolDescBox.instantiate()
	descInstance.setDesc_TowerStatModifier(toolData)

	if shopToolID != -1:
		descInstance.showExtraLine("Cost: " + str(currentShopPrice))

	var xMargin = 10
	var yMargin = 20
	add_child(descInstance)
	descInstance.global_position = get_global_position() + Vector2(size.x + xMargin , yMargin)



func _on_button_pressed() -> void:
	emit_signal("toolSelected", self)
	

