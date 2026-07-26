extends Sprite2D

@export var recoil_skew: float = -0.12
@export var recoil_kick_duration: float = 0.02
@export var recoil_return_duration: float = 0.12

var recoil_tween: Tween

@onready var tower := get_parent()

func _ready() -> void:
	tower.towerInteractOnTarget.connect(setUp)


func setUp( target: Node ):


	flip_h = target.global_position.x > global_position.x

	play_recoil()


func play_recoil() -> void:
	if is_instance_valid(recoil_tween):
		recoil_tween.kill()

	skew = 0.0
	recoil_tween = create_tween()
	recoil_tween.tween_property(self, "skew", recoil_skew, recoil_kick_duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	recoil_tween.tween_property(self, "skew", 0.0, recoil_return_duration) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
