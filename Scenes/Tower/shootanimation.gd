extends Sprite2D

@export var recoil_skew: float = -0.12
@export var recoil_kick_duration: float = 0.02
@export var recoil_return_duration: float = 0.12

var recoilDirection : int

var recoil_tween: Tween

var tower
@onready var shotPoint := $ShotPoint
@onready var attackLine := $AttackLine

var shotPointOriginalX 

func initialize() -> void:
	tower = get_parent()
	print(attackLine)
	tower.towerInteractOnTarget.connect(setUp)

	if shotPoint:
		shotPoint.position = tower.shotPointPos

	shotPointOriginalX = shotPoint.position.x


	print("tower sprite 2d shot point pos:")
	print(tower.shotPointPos, shotPoint.position)
	#print(tower)

func setUp( target: Node ):


	flip_h = target.global_position.x > global_position.x
	
	if target.global_position.x > global_position.x:
		shotPoint.position.x = -shotPointOriginalX
		recoilDirection = 1
	else:
		shotPoint.position.x = shotPointOriginalX
		recoilDirection = -1

	print("shotpoint pos",shotPoint.position)
	
	play_recoil()
	createAttackLine(target)

func createAttackLine( target : Node ):
	attackLine.clear_points()
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
	recoil_skew *= recoilDirection
	recoil_tween = create_tween()
	recoil_tween.tween_property(self, "skew", recoil_skew, recoil_kick_duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	recoil_tween.tween_property(self, "skew", 0.0, recoil_return_duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
