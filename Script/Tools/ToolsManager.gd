extends Node
class_name ToolsManager

var testTool : ToolData = preload("res://Resources/ToolsResource/test.tres")
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
	var dir = DirAccess.open("res://Resources/Tools/")
	if dir == null:
		print("Failed to open Tools directory: res://Resources/Tools/")
		return

	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file.ends_with(".tres"):
			var Tool = load("res://Resources/Tools/" + file)
			if Tool != null and Tool is ToolData:
				tools[Tool.toolName] = Tool
			else:
				print("Skipped invalid tool resource: " + file)

		file = dir.get_next()
	
	print("Loaded " + str(tools.size()) + " tools.")

	dir.list_dir_end()


func addTool(toolData : ToolData):
	Global.toolsList.append(toolData)

	if toolData is TowerStatModifier:
		TowerStatModifierHandler.addModifier(toolData)
	
