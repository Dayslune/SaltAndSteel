extends Node

var cardPickingHandlerScene : PackedScene = preload("res://Scenes/UI/Cards/PickCards.tscn")
var shopScene : PackedScene = preload("res://Scenes/UI/GeneralUI/Shop.tscn")

var topLayer
var midLayer
var bottomLayer
var overwriteLayer

var cardPickingUI
var shopUI

var invalid : bool = false

var layers := {}

#order is bottomLayer (highest) -> topLayer


func _ready() -> void:
	topLayer = get_tree().get_first_node_in_group("TopLayer")
	midLayer = get_tree().get_first_node_in_group("MidLayer")
	bottomLayer = get_tree().get_first_node_in_group("BottomLayer")
	overwriteLayer = get_tree().get_first_node_in_group("OverwriteLayer")

	if topLayer and midLayer and bottomLayer and overwriteLayer:
		print("successfully loaded layers")
		invalid = false

		layers = {
			"top": topLayer,
			"mid": midLayer,
			"bottom": bottomLayer,
			"overwrite": overwriteLayer
		}
	else:
		invalid = true


func show_card_picking_ui() -> void:
	if invalid:
		return

	if cardPickingUI:
		cardPickingUI.queue_free()

	cardPickingUI = cardPickingHandlerScene.instantiate()
	bottomLayer.add_child(cardPickingUI)
	cardPickingUI.cardPicked.connect(on_card_picked)

func hide_card_picking_ui() -> void:
	if cardPickingUI:
		cardPickingUI.queue_free()

func show_shop_ui() -> void:
	if invalid:
		return

	if shopUI:
		shopUI.queue_free()

	shopUI = shopScene.instantiate()
	bottomLayer.add_child(shopUI)

func hide_shop_ui() -> void:
	if shopUI:
		shopUI.queue_free()

func on_card_picked() -> void:
	show_shop_ui()


func addChildToLayer( node : Node, layerName : String ):
	if layers.has(layerName):
		layers[layerName].add_child(node)