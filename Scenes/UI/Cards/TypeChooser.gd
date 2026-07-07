extends Panel


var texture : TextureRect

func setType(towerData : TowerData):
	texture = $TypeTexture

	if texture == null:
		return

	if towerData is SingleTarget:
		texture.texture = load("res://Asset/Icons/Type/Tracker.png") 
	if towerData is AreaOfEffect:
		texture.texture = load("res://Asset/Icons/Type/AreaOfEffect.png")
	
	# will implement polymorphism later.