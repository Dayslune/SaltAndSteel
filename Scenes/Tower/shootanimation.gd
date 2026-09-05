extends Sprite2D

@export var recoil_skew: float = 0.15
@export var recoil_kick_duration: float = 0.02
@export var recoil_return_duration: float = 0.12

var recoilDirection : int = 1

var recoil_tween: Tween

var tower
@onready var shotPoint := $ShotPoint
@onready var attackLine := $AttackLine

var shotPointOriginalX 

func initialize() -> void:
	tower = get_parent()
	print(attackLine)
	tower.towerInteractOnTarget.connect(setUpAnim)

	if shotPoint:
		shotPoint.position = tower.shotPointPos

	shotPointOriginalX = shotPoint.position.x

	offset.x = tower.Stats.spriteOffSetX


	print("tower sprite 2d shot point pos:")
	print(tower.shotPointPos, shotPoint.position)
	deployAnim()
	#print(tower)

@export var deployAnimDurationTransparent : float = 0.3
@export var startingYPosAnimAdd : float = -100
@export var deployAnimDuration : float = 0.5
func deployAnim() -> void:
	modulate = Color(1, 1, 1, 0)
	var originalPos = position
	position.y = originalPos.y + startingYPosAnimAdd
	var deployTween = create_tween()
	deployTween.tween_property(self, "position:y", originalPos.y, deployAnimDuration) \
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	if tower:
		var placeSound = tower.get_node("PlaceSound")
		if placeSound:
			placeSound.pitch_scale = randf_range(0.8, 1.2)
			placeSound.play()
	
	var transparentTween = create_tween()
	transparentTween.tween_property(self, "modulate:a", 1.0, deployAnimDurationTransparent)

func setUpAnim( target: Node ):

	print("SET UP ANIMMMMMMMMM")
	flip_h = target.global_position.x > global_position.x
	
	if target.global_position.x > global_position.x:
		shotPoint.position.x = -shotPointOriginalX
		offset.x = tower.Stats.spriteOffSetX * -1
		recoilDirection = -1
	else:
		shotPoint.position.x = shotPointOriginalX
		offset.x = tower.Stats.spriteOffSetX
		recoilDirection = 1

	print("shotpoint pos",shotPoint.position)
	
	play_recoil()
	createAttackLine(target)

func createAttackLine( target : Node ):
	attackLine.clear_points()

	if target == null:
		return

	attackLine.add_point(attackLine.to_local(shotPoint.global_position))
	attackLine.add_point(attackLine.to_local(target.global_position))
	attackLine.visible = true
	var distimeDiv = randf_range(20,50)
	await get_tree().create_timer(tower.Stats.AttackCooldown/distimeDiv).timeout
	attackLine.visible = false

func play_recoil() -> void:
	if is_instance_valid(recoil_tween):
		recoil_tween.kill()

	skew = 0.0
	recoil_tween = create_tween()
	recoil_tween.tween_property(self, "skew", recoil_skew * recoilDirection, recoil_kick_duration) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	recoil_tween.tween_property(self, "skew", 0.0, recoil_return_duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)



#buggiest code ever but eh they are visual so not that important for now