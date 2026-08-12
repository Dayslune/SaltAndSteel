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
@export var shotPointPosition : Vector2 = Vector2(0,0)
@export var spriteOffSetX : float = 0

@export_group("SFX")
@export var attackSFX : AudioStream = preload("res://Asset/SFX/Tower/lightGunShot.mp3")
@export var attackSFXVolume : float = 1.0
@export var attackSFXDistance : float = 500.0