extends Resource
class_name TowerData

@export var Name : String
@export var id : String
@export var AttackRange : float
@export var PlacementRange : float
@export var TowerTexture : Texture2D
@export var Cost : int
@export var Rarity : String
@export var Damage : float
@export var AttackCooldown : float
@export var Penetration : float = 0

@export var TowerArt : Texture2D
@export var Type : String # For card art purpose
@export var TowerArtCanvasMultiplier : float