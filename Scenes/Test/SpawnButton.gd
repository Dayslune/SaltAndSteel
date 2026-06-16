extends Button

@export var towerRes : Resource
var tower : PackedScene = preload("res://Scenes/Tower/TowerPlacement.tscn")

func _ready() -> void:
	pass 

func _on_pressed() -> void:
	if not Global.isPlacingTower:
		var towerInstance = tower.instantiate()
		towerInstance.TowerStat = towerRes
		get_tree().current_scene.add_child(towerInstance)
