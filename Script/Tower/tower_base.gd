extends Node2D
class_name Tower

signal towerInteractOnTarget(target : Node)

@export var Stats : TowerData
var currentStat : TowerData

#Base statsfg c

var Name : String
var Desc : String
var AttackRange : float
var Cost : int
var Hitbox : CollisionShape2D
var PlacementBox : CollisionShape2D
var Damage : float
var ASP : float
var Type : String
#AOE tower
var AOERadius : float
var shotPointPos : Vector2

var SetupTower

var TowerManager : Node
var towerSprite 

var spriteNode 

func _ready() -> void:

	spriteNode = $TowerSprite

	Stats = Stats #grass is green ahhhh code i wrote for whatever reason but im keeping it for the love of the game.
	currentStat = Stats.duplicate()

	Name = Stats.Name
	AttackRange = Stats.AttackRange
	Cost = Stats.Cost
	
	if spriteNode:
		spriteNode.texture = Stats.TowerTexture
	
	Hitbox = $Range/RangeShape
	PlacementBox = $PlacementRange/RangeShape
	

	Hitbox.shape = Hitbox.shape.duplicate() 
	PlacementBox.shape = PlacementBox.shape.duplicate() 
	# ^ this is so that the hitbox of different towers dont get changed when you place new ones

	Hitbox.shape.radius = AttackRange
	PlacementBox.shape.radius = Stats.PlacementRange

	Damage = Stats.Damage
	ASP = Stats.AttackCooldown
	
	Type = Stats.Type
	shotPointPos = Stats.shotPointPosition
	print("shot Point pos:")
	print(shotPointPos)

	TowerManager = get_tree().get_first_node_in_group("TowerManager")

	towerSprite = $TowerSprite
	if towerSprite:
		towerSprite.initialize()

	#print(Type)
	add_to_group("Tower")

	if Stats is SingleTarget:
		SetupTower = $SingleTarget
		SetupTower.setup(Stats)
		
	elif Stats is AreaOfEffect:
		SetupTower = $AreaOfEffect
		AOERadius = Stats.AOERadius
		SetupTower.setup(Stats)

func _process(delta: float) -> void:
	if Global.isPlacingTower:
		queue_redraw()

func _draw():
	if Global.isPlacingTower:
			var radius2 = Stats.PlacementRange
			draw_circle(Vector2.ZERO, radius2, Color(0.903, 0.287, 0.345, 0.22))
			draw_arc(Vector2.ZERO, radius2, 0, TAU, 32, Color(0.708, 0.159, 0.252, 0.718), 5)


# Damage multiplier
var damageMultiplier : float = 1.0
var flatDamageBonus : float
var percentDamageBonus : float

# Attackspeed Multiplier 
var ASPMultiplier : float = 1.0
var flatASPBonus : float
var percentASPBonus : float

#Range Multiplier 
var rangeMultiplier : float = 1.0
var flatRangeMultiplier : float 
var percentRangeBonus : float

# AOE Multiplier (for AOE tower only)
var AOEMultiplier : float = 1.0
var flatAOEBonus : float
var percentAOEBonus : float


func applyModifier(modifierData : TowerStatModifier):
	damageMultiplier *= modifierData.damageMultiplier_modi
	ASPMultiplier *= modifierData.aspMultiplier_modi
	rangeMultiplier *= modifierData.rangeMultiplier_modi
	
	flatDamageBonus += modifierData.damageFlatModifier_modi
	flatRangeMultiplier += modifierData.rangeFlatModifier_modi
	flatASPBonus += modifierData.aspFlatModifier_modi


	percentDamageBonus += modifierData.damagePercentageModifier_modi
	percentASPBonus += modifierData.aspPercentageModifier_modi
	percentRangeBonus += modifierData.rangePercentageModifier_modi



	#AOE
	AOEMultiplier *= modifierData.AOERadiusMultiplier_modi
	flatAOEBonus += modifierData.AOERadiusFlatModifier_modi
	percentAOEBonus += modifierData.AOERadiusPercentageModifier_modi

	if SetupTower != null and SetupTower.has_method("setStats"):
		SetupTower.setStats()


func _exit_tree() -> void:
	if TowerManager:
		TowerManager.changeCurrentTowerAmount(-1)