# Development 

*warning: since I'm new to game development and software engineering overall, but after 4 months I learned a lot. I realized that most of the logics/systems I wrote early on (like the deck) is quite questionable, however, I decided to keep those logics (mainly because they works well for now).*
*since the project is really large. I won't be able to explain every bit of code, I will mention what I think is important instead.*

The game is made in **Godot 4.x** with **GDscript** and **GDshader**. A large part of the game is data-driven architecture, using **Resource** to makes adding new stuffs easier without hard-coding.

## Game Manager:
- The game manager is actually less important than it sounds. The main thing that it does is initializing other systems and setting up the game. Originally I want it to play a bigger role but as development continued its job remained the same.


## Global:
- **Global.gd** is an Autoload script. It stores the current states of the game *(such as the "isWaveBreak" variable)*, various signals *(events)*, global variables *(Power, the currency)*, and some data stored with arrays *(wave data and tool, aka upgrades, list)*.

## PlayerStats:
- Don't ask why this was separated from Global idk what I was doing back then *(perhaps past me wanted to keep things clean and convenient). It's another Autoload script that contains variables like *powerIncreasePerKill*, which is just a quick and cheap way to make upgrades like *Gain 1 more Power from killing enemy* effortless because I just need to modify the variables in PlayerStats.

## Data-driven Architectures

### Wave Data:
- The wave system is quite a... large system. It uses a data-driven architecture, meaning that creating a new wave doesn't require modifying the wave system itself. Instead, you simply create a new WaveEntry resource and define its SpawnEntrys. Each SpawnEntry represents a group of enemies along with their amount, delay, and spawn timing. The wave system then reads these resources and handles the rest automatically.
- Below is a demonstration of the system:
<p align="center"><img width="491" height="790" alt="image" src="https://github.com/user-attachments/assets/a26be846-5043-4e72-bf55-a3ab83fdcb69" /> </p>

- Handling the waves is actually not that hard. You just read the data, handle the SpawnEntries of a wave to the Spawning System. Using the delays, spawn timeline (*a lot of await get_tree.create_timer().timeout lmfao*),... to determine when to spawn an enemy and which enemy would show up. The wave ends when the duration of the wave runs out (*or when all enemies are killed if it's the **last** wave*).
- The spawn entry values include:
  * **Enemy**: The type of Enemy that would be spawned
  * **Amount**: The amount of enemy that would be spawned.
  * **Delay**: The delay time between each enemy's spawn.
  * **Spawn Timeline**: When the spawn entry started (aka when the mini-wave started)

### Tower Data:
- Towers also has a highly customizable data-driven system. You simply create a new **Tower Resource**. Including combat/mechanic-related variables:
  * **Attack Damage**: The damage the tower deals
  * **Attack Speed**: The attack interval (in second)
  * **Attack Range**: The attack range of the tower
  * **Placement Range**: The secondary range that separate towers (basically distant between towers).
  * **Tower Type**: The type of the tower. (Current it's a String, I'm intending to make it a Resource in the future).
  * **Penetration**: The stat that reduce the effectiveness of the enemy's defense (Read [gameplay documentation](GameplayDocumentation.md) for more details)
- And some visual-related variables:
  * **Name**: Name of the tower.
  * **ID**: ID of the tower. Use in Deckmanager and other deck-related systems.
  * **Tower Art**: The card illustration.
  * **Tower Sprite**: The tower sprites (the actual unit).
  * **Shot Point Position**: Basically where the attack visual (which is just a straight point) should come from.
  * **Sprite Offset**: Offset for the sprite since the texture might not align.
-  As you can see, it's pretty easy to create a brand new tower with this system. However, it's still limited to making basic towers *(different attack damage, interval,...)*. I'm intending to implement more complex systems for the tower *(such as the current Condition system I already have)*, allowing for the creation of more unique designs.

<p align="center"><img width="300" height="500" alt="image" src="../readmeassets/TowerResourceExample.png" /> </p>
<p align="center">The data of the Scout Tower</p>

### Condition and Action:
- This is, in my opinion, the most complex data-driven system I've implemented in this project so far. Below is an demonstration of it:
<p align="center"><img width="300" height="500" alt="image" src="../readmeassets/ConditionSystem_akaPeakEngineering.png" /> </p>
- As you can see, the Condition system interact with the Action system. So we'll explain Action first because it's the simpler one *(currently)*.

#### Action:
```
extends Resource
class_name Action

func playActionOnTarget(target : Node, source : Node = null):
    pass

func endAction():
    pass
```

- Action is a Resource. However, it's rather a base for different action types (for example, Apply Status Effect, Deal Damage, etc). For those who doesn't know, since scripts/subclasses that inherited a Resource will overwrite its function, when I need to play any action, I just need to use *playActionOnTarget* rather than using a lot of it to check the type of action. 

```
extends Action 
class_name ApplyStatusEffect

@export var effects: Effects

func playActionOnTarget(target: Node, source: Node = null):
	apply(target, effects, source)

func apply(target: Node, effects: Effects, source: Node):

	if target == null or not target.is_in_group("Enemy"):
		print("Enemy node not found")
		return
	
	print("applied effect!")
	print(effects.effects)
	for statusEffect in effects.effects:
		print("yey")
		target.emit_signal("applyEffect", statusEffect)
```
For example, in ApplyStatusEffect *(ignore the unserious debug messages pls)*, I just need to call playActionOnTarget, so instead checking ``` if action is ApplyStatusEffect -> apply(...)``` and I can just go ``` applyActionOnTarget(...)``` for every type of action. The code responsible for executing the action DOESN'T need to know what type of action it's dealing it, it just saw Action and call playActionOntarget. 
- I did this so that when I added a new Action subclass, I don't need to modify the code that executes action. I eventually learned that this is called **polymorphism**. I was actually really happy when I discovered this.

#### Condition
- Since the game can has multiple conditions running at once, instead of having one node running everything, I decided to make each conditions to have a responsible node. When there's a new condition added to the scene, the **Condition Manager** would create a new **smaller Condition node** that represent that **condition**.
	```
	var enemyHitCondition: PackedScene = preload("res://Scenes/ConditionManager/EnemyHitCondition.tscn")

	func applyCondition( condition : ConditionData ):
	var conditionNode

	if condition is EnemyHitConditionData:
		conditionNode = enemyHitCondition.instantiate()

	get_tree().current_scene.add_child.call_deferred(conditionNode)

	conditionNode.setup(condition)

This is how it look like in the script. EnemyHitCondition is already a premade scene that executes the condition by itself. Below is the EnemyHitCondition code, which is an example of what these sub-condition scripts look like.
<details>
	<summary> <b>EnemyHitCondition Code</b> </summary>
	
	extends Node
	var requiredHitCount : int 
	var actions: Array[Action]
	var applyToTowerType : String = ""
	var cooldown : float = 0.0
	var cooldownEndsAt : int = 0
	
	var enemyData : Dictionary[String, int] 
	#use hashmap aka dictionary to store the enemy hit counts
	
	var effectApplier 
	
	func _ready() -> void:
		effectApplier = get_tree().get_first_node_in_group("EffectApplyHandler")
	
	func setup( condition : EnemyHitConditionData ) -> void:
		
		requiredHitCount = condition.hitAmount
		actions = condition.action
		applyToTowerType = condition.hitByTowerType
		cooldown = maxf(condition.cooldown, 0.0)
	
		print("condition set up!")
	
		Global.TowerAttackEnemy.connect(towerAttackEnemy) 

	func towerAttackEnemy( tower : Node, enemy : Node, damage : float):
		
		print("towerAttacking!!")
	
		if Time.get_ticks_msec() < cooldownEndsAt:
			return
	
		if not tower or not tower.is_in_group("Tower"):
			print("not tower")
			return 
		
		if not enemy or not enemy.is_in_group("Enemy"):
			print("not enemy")
			return 
		
		if tower.Type != applyToTowerType and applyToTowerType != "":
	
			print("different tower TYPE!")
	
			return 
	
		print("condition receive successful")
	
		var enemyId = str(enemy.get_instance_id())
	
		if enemyData.has(enemyId):
			enemyData[enemyId] += 1
		else:
			enemyData[enemyId] = 1
		
	
		if enemyData[enemyId] == requiredHitCount:
			#print(enemyData, " apply Effect!!!!!!!!!!!!!")
	
			enemyData.erase(enemyId)
			cooldownEndsAt = Time.get_ticks_msec() + roundi(cooldown * 1000.0)
			playActions(enemy, tower)


	func playActions(target : Node, source : Node = null):
		if actions == null:
			print("invalid actions list")
			return
		for action in actions:
			if action == null or not action.has_method("playActionOnTarget"):
				print("invalid action")
				continue 

			action.playActionOnTarget(target, source)

</details>

*(I haven't applied polymorphism for ConditionManager yet since I haven't learned it back then, yes the Action system is made long after the condition system)*. 






