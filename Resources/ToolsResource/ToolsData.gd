extends Resource
class_name ToolData

enum ToolType {
    TowerStatModifier,
    ConditionModifier,
    PlayerStatChange
}

@export var toolName : String
@export var toolDescription : String
@export var toolIcon : Texture2D
@export var toolType : ToolType
@export var toolRarity : String #Common, Rare.