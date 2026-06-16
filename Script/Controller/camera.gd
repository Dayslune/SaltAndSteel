extends CharacterBody2D
@export var DefaultCamSpeed := 200
var Speed

func _ready() -> void:
	
	Speed = DefaultCamSpeed


func _physics_process(delta: float) -> void:
	
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("CameraMoveRight") - Input.get_action_strength("CameraMoveLeft")
	direction.y = Input.get_action_strength("CameraMoveDown") - Input.get_action_strength("CameraMoveUp")
	# get action strength return 0 or 1 based on whether you are pressing the required input or not. 
	
	direction = direction.normalized()
	
	velocity = direction * Speed
	
	move_and_slide()
	
