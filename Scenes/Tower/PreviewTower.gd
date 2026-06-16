extends Node2D

var showPreview : bool = false
var mouseinPlacementRange : bool = false

var attackRangeShape
var placementRangeShape

var placementRadius : float
var attackRadius : float

var towerNode

var cardBase := preload("res://Scenes/UI/Cards/CardBase.tscn")


func _ready() -> void:

	towerNode = get_parent()
	
	placementRangeShape = towerNode.get_node("PlacementRange").get_node("RangeShape")
	#placementRadius = placementRangeShape.shape.radius

	attackRangeShape = towerNode.get_node("Range").get_node("RangeShape")
	#attackRadius = attackRangeShape.shape.radius


func _process(delta: float) -> void:

	attackRadius = attackRangeShape.shape.radius
	placementRadius = placementRangeShape.shape.radius

	if mouseinPlacementRange:

		if not showPreview:
			towerNode.modulate = Color(0, 1, 0, 0.5)

		if Input.is_action_just_pressed("M1") and not showPreview:
			towerNode.modulate = Color(1, 1, 1, 1)
			showPreview = true
			showCard()


			queue_redraw()
	else:
		towerNode.modulate = Color(1, 1, 1, 1)
		if Input.is_action_just_pressed("M1") and showPreview:
			showPreview = false
			hideCard()
			queue_redraw()


func _on_placement_range_mouse_entered() -> void:
	mouseinPlacementRange = true

func _on_placement_range_mouse_exited() -> void:
	mouseinPlacementRange = false

func _draw():
	if showPreview:
		draw_circle(Vector2.ZERO, attackRadius, Color(0.267, 0.542, 0.884, 0.22))
		
		draw_arc(Vector2.ZERO, attackRadius, 0, TAU, 32, Color(1.0, 1.0, 1.0, 1.0), 5)
		
		draw_circle(Vector2.ZERO, placementRadius, Color(0.903, 0.287, 0.345, 0.22))
		draw_arc(Vector2.ZERO, placementRadius, 0, TAU, 32, Color(1.0, 1.0, 1.0, 1.0), 5)

@export var showCardScaleMultiply = Vector2(3,3)

var cardInst

func showCard():
	cardInst = cardBase.instantiate()
	cardInst.cardInfo = towerNode.currentStat #dont use cardData here because this is a placed Tower. Not a card
	cardInst.scale = showCardScaleMultiply
	cardInst.global_position = global_position + Vector2(50,-50) #vector2 for offset
	get_tree().current_scene.add_child(cardInst)

func hideCard():
	cardInst.queue_free()