extends Line2D

var path : Path2D

func _ready():
	path = get_tree().get_first_node_in_group("EnemyPath")
	var points = path.curve.get_baked_points()
	for point in points:
		add_point(point)

	width = 150
	default_color = Color(1, 0.1, 0.1, 0.8)
