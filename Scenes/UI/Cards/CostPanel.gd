extends Panel


func setCost(cost : String):
	var label = $Label 
	if label == null:
		return 
	
	label.text = "Cost: " + cost 