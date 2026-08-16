extends Button

@export var textInfo : String = "Button"
@export var textSize : int = 92
@export var textColor : Color = Color.WHITE
@export var textFont : Font

@export var hoverAnim : bool = true
@export var animDur : float = 0.2
@export var animScale : float = 1.25

@export var function : String = ""

@export var shadow : bool = true
var originalPosition : Vector2
var label : Label
var visual

func _ready():
	originalPosition = position
	label = $Visual/Label
	visual = $Visual
	setText()
	setVisual()


func setText():
	
	if label != null and label is Label:
		label.text = textInfo
		label.label_settings.font_size = textSize
		label.label_settings.font_color = textColor

		if textFont != null:
			label.label_settings.font = textFont
		
		if not shadow:
			label.label_settings.shadow_size = 0

	print("textInfo: ", textInfo)
	print("textSize: ", textSize)
	print("textColor: ", textColor)

	print("actual text size: ", label.get_theme_font_size("font_size"))


func setVisual():
	if visual != null:
		visual.pivot_offset = visual.size / 2


func _on_mouse_exited() -> void:
	print("Mouse exited button: ", textInfo)
	if hoverAnim:
		var tween = create_tween()
		tween.tween_property(visual, "scale", Vector2(1,1), animDur).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_mouse_entered() -> void:
	print("Mouse entered button: ", textInfo)
	if hoverAnim:
		var tween = create_tween()
		tween.tween_property(visual, "scale", Vector2(animScale, animScale), animDur).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_pressed() -> void:
	
	if self.has_method(function):
		self.call(function)
	else:
		print("function not found: ", function)

func startGame():
	get_tree().change_scene_to_file("res://MainGame.tscn")

func quitGame():
	get_tree().quit()


func credits():
	var main_menu = get_tree().get_current_scene()
	if main_menu.has_method("creditsFunc"):
		main_menu.call("creditsFunc")
	else:
		print("creditsFunc method not found in main menu scene.")


@export var paralaxEffect : bool = false 
@export var strength : float = 0.03

func _process(delta) -> void:
	if paralaxEffect == false:
		return
	var mouse_pos = get_viewport().get_mouse_position()
	var center = get_viewport_rect().size / 2
	var offset = (mouse_pos - center) * strength
	position = originalPosition + offset