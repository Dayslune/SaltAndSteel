extends Node
class_name ToolsManager

var testTool : ToolData = preload("res://Resources/ToolsResource/test.tres")
@export var loadingTools : Array[ToolData]
var tools : Dictionary = {}
var TowerStatModifierHandler 

func initialize():
	TowerStatModifierHandler = $TowerStatModifier
	load_tools()

	#for Tool in tools.values():
	#	print(Tool.toolName)

#Test 

func _ready():
	initialize()


func load_tools():
	tools.clear() 
	for loadTool in loadingTools:
		tools[loadTool.toolName] = loadTool
	
	print("loaded tools: ", tools)


func addTool(toolData : ToolData):
	Global.toolsList.append(toolData)

	if toolData is TowerStatModifier:
		TowerStatModifierHandler.addModifier(toolData)
	
