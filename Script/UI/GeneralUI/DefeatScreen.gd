extends Control

var gameManager 

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("GameManager")

func _on_try_again_button_pressed() -> void:
	if gameManager:
		gameManager.restart()
