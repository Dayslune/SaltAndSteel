extends Node2D

var showPreview : bool = false
var mouseinPlacementRange : bool = false

var attackRangeShape
var placementRangeShape

var placementRadius : float
var attackRadius : float

var towerNode

var cardBase := preload("res://Scenes/UI/Cards/CardBase.tscn")
var retreatButton : PackedScene = preload("res://Scenes/UI/Tower/RetreatButton.tscn")

@export var previewModulate : Color


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
			towerNode.modulate = previewModulate
		else:
			towerNode.modulate = Color(1, 1, 1, 1)

	else:
		towerNode.modulate = Color(1, 1, 1, 1)
		

func _unhandled_input(event: InputEvent) -> void: # unhandled input only handle inputs that no other UIs handle. for example if you click on the retreat button then its already a handled input, if you click on empty space thats unhandled input. js learned abt it today.

	if not event.is_action_pressed("M1"):
		return 
	
	if mouseinPlacementRange and not showPreview:
		towerNode.modulate = Color(1, 1, 1, 1)
		showPreview = true

		showRetreatButton()
		showCard()

		queue_redraw()

	
	elif not mouseinPlacementRange and showPreview:
		showPreview = false

		hideCard()
		hideRetreatButton()

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
	cardInst.global_position = Vector2(50,-50) #vector2 for offset
	add_child(cardInst)


var retreatButtonInst

func showRetreatButton():
	retreatButtonInst = retreatButton.instantiate()
	if retreatButtonInst and towerNode:
		retreatButtonInst.assignTowerNode(towerNode)
	
	retreatButtonInst.global_position = Vector2(50,-170)
	add_child(retreatButtonInst)

func hideCard():
	if cardInst:
		cardInst.queue_free()

func hideRetreatButton():
	if retreatButtonInst:
		retreatButtonInst.queue_free()