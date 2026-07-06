extends Panel

@export var expandX : float 
@export var expandY : float

func setup(text: String):
	visible = false #turns visible to false so it prevents flicking. because we have to wait 2 frames, players will see the size change.
	var label = $Stats

	if label:
		label.text = text 
	else:
		print("label not label")
	

	for i in range(2):
		await get_tree().process_frame

	if label:
		size.y = label.size.y + expandY * 2
		size.x = label.size.x + expandX * 2
		
		print("Panel size: ", size.y, "Text size: ", label.size.y  )

	visible = true #only reveal when size have changed

#func _process(delta: float) -> void:
	print($Stats.size.y)
