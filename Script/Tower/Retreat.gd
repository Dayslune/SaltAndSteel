extends Control

var towerNode

func assignTowerNode( node : Node):
	towerNode = node 


func _on_retreat_button_pressed() -> void:
	if towerNode:
		towerNode.queue_free()


