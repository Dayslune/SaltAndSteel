extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defeatAnimation()

var parent : Node = null
@export var secondSFXDelay : float = 1.0

func defeatAnimation() -> void:
	parent = get_parent()

	var panel = parent.get_node("Panel")
	var label = parent.get_node("Label")
	var button = parent.get_node("Button")

	if not panel or not label or not button:
		print("cant find required nodes for animation")
		return
	
	panelAnim(panel)
	labelAnim(label)

	await get_tree().create_timer(secondSFXDelay).timeout #secondSFXDelay is the time of the build up of the first sfx

	playBoomSFX()

func playBoomSFX():
	var boomSFX = parent.get_node("Boom")
	if boomSFX:
		boomSFX.play()


@export var animDurPanel : float = 2
@export var animDurLabelSize : float = 1
@export var animDurLabelModul : float = 0.2
@export var animDurButton : float = 1


func panelAnim(panel : Panel):
	panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1, animDurPanel).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func labelAnim(label : Label):
	label.scale = Vector2(100,100)
	label.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1, animDurLabelModul).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var tween2 = create_tween()
	tween2.tween_property(label, "scale", Vector2(1,1), animDurLabelSize).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	await tween2.finished

	var labelShockWaveNode = parent.get_node("LabelShockWaveEffect")
	if labelShockWaveNode:
		labelShockWaveNode.play_shock_wave_effect()
	
	var flashBangNode = parent.get_node("THINKSFASTCHUCKLENUT")
	if flashBangNode:
		flashBangNode.playFLASHBLANGanim()


