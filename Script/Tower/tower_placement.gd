extends Node2D

@onready var TDTexture = $TowerTexture
var TowerBase : PackedScene = preload("res://Scenes/Tower/Tower_Base.tscn")
@export var TowerStat : TowerData
var AttackRange : float
var PlacementRange : float
var OverlappingTowers : Array = []
var placement_zone_areas : Array = []
var PowerCost : int
var inPlacementZone : bool

var StatsModifierHandler

var TowerManager

var placementZoneVisual : Node2D

var checkValidSpot : bool = true

signal placementFinished(success : bool)

var map : Node2D

func _ready() -> void:
	Global.isPlacingTower = true
	AttackRange = TowerStat.AttackRange
	PlacementRange = TowerStat.PlacementRange
	TDTexture.texture = TowerStat.TowerTexture
	PowerCost = TowerStat.Cost
	
	inPlacementZone = false

	var PlacementBox = $TowerTexture/Area2D/RangeShape
	PlacementBox.shape.radius = PlacementRange

	StatsModifierHandler = get_tree().get_first_node_in_group("TowerStatModifierHandler")
	TowerManager = get_tree().get_first_node_in_group("TowerManager")


	map = get_tree().get_first_node_in_group("Map")
	placementZoneVisual = get_tree().get_first_node_in_group("PlacementZoneVisual")
	
	if placementZoneVisual:
		placementZoneVisual.showZone()
	

func _process(delta: float) -> void:
	var pos = get_global_mouse_position()
	global_position = pos
	queue_redraw()
	
	inPlacementZone = is_fully_inside_any_placement_zone()

	if OverlappingTowers.is_empty() and inPlacementZone and checkTowerLimit():
		checkValidSpot = true
	else:
		checkValidSpot = false
	



	if Input.is_action_just_pressed("M1") and checkValidSpot:
		
		#This is temporary
		if not Global.payPower(PowerCost):
			Global.isPlacingTower = false
			emit_signal("placementFinished",false)
			queue_free()
			return
		
		Global.ChangeInPower.emit()
		placeTower()
		Global.isPlacingTower = false
		emit_signal("placementFinished",true)
		queue_free()
		
	if Input.is_action_just_pressed("M2"):
		Global.isPlacingTower = false
		emit_signal("placementFinished",false)
		queue_free()

func _exit_tree() -> void:
	if placementZoneVisual:
		placementZoneVisual.hideZone()

func placeTower()->void:
	var TowerInst = TowerBase.instantiate()
	TowerInst.Stats = TowerStat.duplicate()
	TowerInst.global_position = global_position
	get_tree().current_scene.add_child(TowerInst)
	#Apply stat modifiers to new towers

	if TowerManager:
		TowerManager.changeCurrentTowerAmount( 1 )

	StatsModifierHandler.applyToNewTower(TowerInst.Type,TowerInst)

func _draw(): #range circle and placement range. 
	var radius = AttackRange
	var radius2 = PlacementRange
	
	if checkValidSpot:
		
		draw_circle(Vector2.ZERO, radius, Color(0.267, 0.542, 0.884, 0.22))
		
		draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Color(1.0, 1.0, 1.0, 1.0), 5)
		
		draw_circle(Vector2.ZERO, radius2, Color(0.903, 0.287, 0.345, 0.22))
		draw_arc(Vector2.ZERO, radius2, 0, TAU, 32, Color(1.0, 1.0, 1.0, 1.0), 5)
		
	else:
		
		draw_circle(Vector2.ZERO, radius2, Color(0.671, 0.0, 0.204, 0.58))
		
		draw_arc(Vector2.ZERO, radius2, 0, TAU, 32, Color(0.58, 0.0, 0.0, 0.82), 5)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlacementRange") and not OverlappingTowers.has(area):
		OverlappingTowers.append(area)
	
	if area.is_in_group("PlacementZone") and not placement_zone_areas.has(area):
		placement_zone_areas.append(area)
		

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlacementRange"):
		OverlappingTowers.erase(area)
	
	if area.is_in_group("PlacementZone"):
		placement_zone_areas.erase(area)
		inPlacementZone = false


func is_fully_inside_any_placement_zone() -> bool:
	if placement_zone_areas.is_empty():
		return false

	var placement_shape = $TowerTexture/Area2D/RangeShape
	if placement_shape == null or not placement_shape is CollisionShape2D:
		return false

	var shape = placement_shape.shape
	if shape == null:
		return false

	var sample_points: Array[Vector2] = []
	if shape is CircleShape2D:
		var radius = shape.radius
		sample_points = [
			Vector2.ZERO,
			Vector2(radius, 0.0),
			Vector2(0.0, radius),
			Vector2(-radius, 0.0),
			Vector2(0.0, -radius)
		]
	elif shape is RectangleShape2D:
		var half_size = shape.size / 2.0
		sample_points = [
			Vector2(-half_size.x, -half_size.y),
			Vector2(half_size.x, -half_size.y),
			Vector2(half_size.x, half_size.y),
			Vector2(-half_size.x, half_size.y),
			Vector2.ZERO
		]
	elif shape is CapsuleShape2D:
		var radius = shape.radius
		var half_height = shape.height / 2.0
		sample_points = [
			Vector2.ZERO,
			Vector2(radius, 0.0),
			Vector2(-radius, 0.0),
			Vector2(0.0, half_height),
			Vector2(0.0, -half_height)
		]
	else:
		return false

	for zone_area in placement_zone_areas:
		var fully_inside = true
		for point in sample_points:
			var world_point = placement_shape.global_transform * point
			if not is_point_inside_zone(zone_area, world_point):
				fully_inside = false
				break
		if fully_inside:
			#print("TRUE")
			return true

	return false


func is_point_inside_zone(zone_area: Area2D, point: Vector2) -> bool:
	for child in zone_area.get_children():
		if child is CollisionPolygon2D:
			var transformed_polygon: PackedVector2Array = []
			for polygon_point in child.polygon:
				transformed_polygon.append(child.global_transform * polygon_point)
			if is_point_inside_polygon(point, transformed_polygon):
				return true
		elif child is CollisionShape2D and child.shape is CircleShape2D:
			var circle_shape: CircleShape2D = child.shape
			if point.distance_to(child.global_position) <= circle_shape.radius:
				return true
		elif child is CollisionShape2D and child.shape is RectangleShape2D:
			var rect_shape: RectangleShape2D = child.shape
			var half_size = rect_shape.size / 2.0
			var local_point = child.global_transform.affine_inverse() * point
			if abs(local_point.x) <= half_size.x and abs(local_point.y) <= half_size.y:
				return true

	return false

# ^ im too lazy to explain allat but these are pretty easy



func is_point_inside_polygon(point: Vector2, polygon: PackedVector2Array) -> bool:
	if polygon.size() < 3:
		return false

	var inside = false
	var j = polygon.size() - 1
	for i in range(polygon.size()):
		var xi = polygon[i].x
		var yi = polygon[i].y
		var xj = polygon[j].x
		var yj = polygon[j].y

		#the idea is making an infinite horizontal ray (point to the right) and check if it intersects 
		#with the edges that these points created.

		var intersects = ((yi > point.y) != (yj > point.y)) and (point.x < (xj - xi) * (point.y - yi) / (yj - yi) + xi)

		#^ this is the most important part of the formula.
		# basically, first you have to check if the ordinate (tung độ) is "between" the ordinate of the vector.
		# then, you find the abscissa (hoành độ) of the intersection point.
		# to find the abscissa of the intersection, its basically standard equation of a line (aka phương trình chính tắc của một đường thằng), its a long explanation so i wont put it here.
		# if it's greater than point.x then that means the "ray" intersects with the edge. (greater because the ray is pointing to the right)

		# v then you "reverse" the inside variable.
		# imagine it like this, the point is outside of a square, then that means it's ray is intersecting with 
		# 2 edges, so that is "inside = not inside" 2 times, returning false.
		# if its inside then it will only intersects with 1 edge.
		# same applies for polygons with more edges, whenever the ray intersects with an even number then the point is out, if its odd then the point is inside.

		# tbh this might not be a good explanation, but ts is how i understand it.

		if intersects:
			inside = not inside
		j = i

	return inside

# ^ so i didnt implement this myself. i did ask AIs for help. I will write the comments and explanation tmr cuz now its 11:46 pm. I do understand it briefly and its some sort of raycasting tho. 
# update: i have wrote the comments. actually takes me a while to understand this formula: (xj - xi) * (point.y - yi) / (yj - yi) + xi

func checkDistanceToPath()	-> bool: #Currently unused system
	var path = get_tree().get_first_node_in_group("Path")
	var points = path.curve.get_baked_points() #get the points in the path
	
	for point in points:
		if global_position.distance_to(point) <= PlacementRange + map.pathWidth/2: # divide width by 2 bc the points are in the center of the path
			return false
	
	return true


func checkTowerLimit() -> bool:

	if TowerManager == null:
		print("cant fine tower manager")
		return true
	
	if TowerManager.currentTowerAmount == TowerManager.currentTowerLimit:
		print("tower limit reached")
		return false
	else:
		return true

