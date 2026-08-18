extends Node

var mapMusicPlayer : AudioStreamPlayer2D = null

func _ready() -> void:
	Global.RunEnd.connect(stopMapMusic)


func getMapMusicPlayer():
	mapMusicPlayer = get_tree().get_first_node_in_group("MapMusic")
	if mapMusicPlayer == null:
		print("No MapMusicPlayer found in current scene!")
	else:
		print("music player found")
	

func stopMapMusic():
	if mapMusicPlayer:
		mapMusicPlayer.stop()
