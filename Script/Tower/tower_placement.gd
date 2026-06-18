extends Node2D

@onready var TDTexture = $TowerTexture
var TowerBase : PackedScene = preload("res://Scenes/Tower/Tower_Base.tscn")
@export var TowerStat : TowerData
var AttackRange : float
var PlacementRange : float
var OverlappingTowers : Array = []
var PowerCost : int

var StatsModifierHandler

var TowerManager

var checkValidSpot : bool = true

signal placementFinished(success : bool)

var map : Node2D

func _ready() -> void:
	Global.isPlacingTower = true
	AttackRange = TowerStat.AttackRange
	PlacementRange = TowerStat.PlacementRange
	TDTexture.texture = TowerStat.TowerTexture
	PowerCost = TowerStat.Cost
	
	var PlacementBox = $TowerTexture/Area2D/RangeShape
	PlacementBox.shape.radius = PlacementRange

	StatsModifierHandler = get_tree().get_first_node_in_group("TowerStatModifierHandler")
	TowerManager = get_tree().get_first_node_in_group("TowerManager")

	map = get_tree().get_first_node_in_group("Map")

func _process(delta: float) -> void:
	var pos = get_global_mouse_position()
	global_position = pos
	queue_redraw()
	
	if OverlappingTowers.is_empty() and checkDistanceToPath() and checkTowerLimit():
		checkValidSpot = true
	else:
		checkValidSpot = false
	



	if Input.is_action_just_pressed("M1") and checkValidSpot:
		
		#This is temporary
		if not Global.payPower(PowerCost):
			Global.isPlacingTower = false
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

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlacementRange"):
		OverlappingTowers.erase(area)


func checkDistanceToPath()	-> bool:
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
