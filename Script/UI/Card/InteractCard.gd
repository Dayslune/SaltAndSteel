extends Control

var cardData 

signal cardSelected(card, cardNode)

func _on_interaction_pressed() -> void:
	emit_signal("cardSelected", cardData, self)


# unused now 