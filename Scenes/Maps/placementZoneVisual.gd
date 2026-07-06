extends Node2D


var map 
var placementZone 

func _ready() -> void:

	visible = false
	map = get_parent()
	placementZone = get_tree().get_first_node_in_group("PlacementZone")

	#print("placementZoneVisual: ", placementZone)
	#print("placementZoneVisual children: ", placementZone.get_children())

	createVisual()

func createVisual():
	
	for polygon in placementZone.get_children():
		if polygon is CollisionPolygon2D:

			#print(polygon)

			var newPolygon = Polygon2D.new()
			newPolygon.polygon = polygon.polygon
			newPolygon.color = Color(0, 1, 0, 0.3)
			add_child(newPolygon)

func showZone():
	visible = true 

func hideZone():
	visible = false
