extends Control

var enemyListPanel : RichTextLabel
var waveSystem : Node
var radarPanel : Panel
var flashPanel : Panel

func _ready() -> void:
	enemyListPanel = $Panel/UpcomingEnemyList
	radarPanel = $Panel
	flashPanel = $Panel/Flash
	waveSystem = get_tree().get_first_node_in_group("WaveSystem")
	Global.WaveEnd.connect(update_upcoming_enemies)
	Global.NextWave.connect(inWave)
	play_open_animation()


func play_open_animation() -> void:
	radarPanel.pivot_offset = radarPanel.size / 2.0
	radarPanel.scale.y = 0.05
	radarPanel.scale.x = 1.5
	radarPanel.modulate = Color(2.5, 2.5, 2.5, 1.0)
	enemyListPanel.modulate = Color(1.0, 1.0, 1.0, 0.0)

	var panel_tween := create_tween().set_parallel()
	var panel_tween2 := create_tween().set_parallel()
	var xtween := create_tween().set_parallel()
	var flashtween := create_tween().set_parallel()
	flashPanel.visible = true
	panel_tween.tween_property(radarPanel, "modulate", Color(2.5, 2.5, 2.5, 0.0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	panel_tween.tween_property(radarPanel, "scale:y", 1.0, 0.075).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	xtween.tween_property(radarPanel, "scale:x", 1.0, 0.03).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	panel_tween2.tween_property(radarPanel, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	await panel_tween.finished
	await get_tree().create_timer(0.1).timeout
	flashPanel.visible = false

	enemyListPanel.modulate = Color(2.5, 2.5, 2.5, 1.0)
	var text_tween := create_tween()
	text_tween.tween_property(enemyListPanel, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func inWave() -> void:
	enemyListPanel.clear()
	enemyListPanel.text = "[center][b]://WAVE IN PROGRESS[/b][/center]"
	enemyListPanel.modulate = Color(2.5, 2.5, 2.5, 1.0)
	var text_tween := create_tween()
	text_tween.tween_property(enemyListPanel, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func update_upcoming_enemies() -> void:
	if waveSystem == null:
		enemyListPanel.clear()
		return

	var next_wave_index := Global.CurrentWave + 1
	if next_wave_index >= waveSystem.waves.size():
		enemyListPanel.clear()
		return
	
	enemyListPanel.text = "[b]://UPCOMING ENEMIES[/b]\n \n"

	var next_wave: WaveEntry = waveSystem.waves[next_wave_index]
	var enemy_lines: Array[String] = []
	for spawn_entry in next_wave.entries:
		var enemy_data := spawn_entry.Enemy as EnemyData
		if enemy_data == null:
			continue

		enemy_lines.append(
			"[b]>_ x%d enemies with:[/b] \n %s HP/%s DEF/%s SPEED" % [
				spawn_entry.amount,
				format_stat(enemy_data.HP),
				format_stat(enemy_data.Defense),
				format_stat(enemy_data.Speed)
			]
		)

	enemyListPanel.text += "\n \n".join(enemy_lines)


func format_stat(value: float) -> String:
	if is_equal_approx(value, round(value)):
		return str(int(value))
	return str(value)
