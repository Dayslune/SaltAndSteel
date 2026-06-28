extends CharacterBody2D

@export var DefaultCamSpeed := 200
@export var BaseZoom: Vector2 = Vector2(0.4, 0.4)
@export var MinZoom: Vector2 = Vector2(0.25, 0.25)
@export var MaxZoom: Vector2 = Vector2(1.0, 1.0)
@export var ZoomStep := 0.05
@export var ZoomSmoothSpeed := 8.0

var Speed: float
var target_zoom: Vector2
var camera_2d: Camera2D

func _ready() -> void:
	Speed = DefaultCamSpeed
	camera_2d = get_node_or_null("Camera2D")
	if camera_2d:
		camera_2d.zoom = BaseZoom
		target_zoom = BaseZoom
	else:
		target_zoom = BaseZoom

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("CameraMoveRight") - Input.get_action_strength("CameraMoveLeft")
	direction.y = Input.get_action_strength("CameraMoveDown") - Input.get_action_strength("CameraMoveUp")
	# get action strength return 0 or 1 based on whether you are pressing the required input or not.
	
	direction = direction.normalized()
	velocity = direction * Speed
	move_and_slide()

	if camera_2d:
		var smooth_t = clamp(ZoomSmoothSpeed * delta, 0.0, 1.0)
		var new_zoom = camera_2d.zoom.lerp(target_zoom, smooth_t)
		new_zoom.x = clamp(new_zoom.x, MinZoom.x, MaxZoom.x)
		new_zoom.y = clamp(new_zoom.y, MinZoom.y, MaxZoom.y)
		camera_2d.zoom = new_zoom

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed: #for scrolling mouse
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_change_zoom(-ZoomStep)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_change_zoom(ZoomStep)


func _change_zoom(delta: float) -> void:
	target_zoom.x = clamp(target_zoom.x + delta, MinZoom.x, MaxZoom.x)
	target_zoom.y = clamp(target_zoom.y + delta, MinZoom.y, MaxZoom.y)

