extends Node

#why didnt i use the default godot y-sort?
#because the enemies are a children of path2d nodes, so unfortunately, you cannot sort that.
#thats the best i can do at explaining it

var objects

func _process(delta: float) -> void:
	objects = get_tree().get_nodes_in_group("Object")

	if objects.size() == 0:
		return 

	objects.sort_custom(func(a,b): return a.global_position.y<b.global_position.y)	
	# ^ sort objects based on their y position.

	for index in objects.size():
		objects[index].z_index = index
