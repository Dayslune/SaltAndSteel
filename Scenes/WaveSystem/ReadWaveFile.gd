class_name WaveLoader


func start(map : String) -> void:
	load_waves_from_folder("res://Data/Maps/" + map)


static func load_waves_from_folder(path : String):
	path = "res://Data/Maps/" + path
	var waves : Array[WaveEntry] = []
	var dir = DirAccess.open(path)
	
	if dir == null:
		print("Failed to open directory!")
		return 
	
	dir.list_dir_begin()
	var fileName = dir.get_next()
	
	while not fileName == "":
		if not dir.current_is_dir():
			if fileName.ends_with(".tres"):
				var spePath = path + "/" + fileName
				var waveData = load(spePath)
				
				if waveData is WaveEntry:
					waves.append(waveData)
		
		fileName = dir.get_next()
	
	dir.list_dir_end()
	return waves
