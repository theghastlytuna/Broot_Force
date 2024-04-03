extends Node2D
class_name Unit

##The amount of health a unit has
@export var health : float
@export var hittable : bool = true
@export var type: UnitType
@export var cost: int
##Float which represents the percentage of poison damage negated,
##where 0 is no damage negation and 1 is 100 percent damage negation
@export var poisonResistance : float
##Float which represents the percentage of melee damage negated,
##where 0 is no damage negation and 1 is 100 percent damage negation
@export var meleeResistance : float
##The unit's health bar
var healthBar : TextureProgressBar

var isDead : bool = false

const deathSound: AudioStream = preload("res://Sounds/SFX/death.mp3")
const painSound: AudioStream = preload("res://Sounds/SFX/pain.mp3")
const vehicleSound: AudioStream = preload("res://Sounds/SFX/vehicle.mp3")
const vehicleExplosion: AudioStream = preload("res://Sounds/SFX/explosion.mp3")
const vehicleDamage: AudioStream = preload("res://Sounds/SFX/metalCrunch.mp3")



#going to put the enum here so we can easily access it using Unit.UnitType
enum UnitType{
	UNDEAD_SMALL_ANIMAL,
	UNDEAD_HUMAN,
	UNDEAD_LARGE_ANIMAL,
	UNDEAD_ANCIENT_CREATURE,
	UNDEAD_DINOSAUR
	}

enum AttackType{
	MELEE,
	RANGED,
	VEHICLE,
	POISON
	}
	
enum TowerType{
	THORN_WALL,
	FLYTRAP_CLUSTER,
	TOXIC_BLOOM,
	THORN_VINES,
	SEED_BOMBER,
	BOMBER_FRUIT,
	SPORE_SPRAYER
	}

#this is the total amount of damage taken
#im doing it like this in case we want units to be able to heal themselves later, there has to be a way to have a units max health
var damageTaken : float

##Emits when the unit is damaged
signal onDamaged(args)
##Emits when the unit dies (and is destroyed)
signal onDie

func _ready():
	SoundManager.set_default_sound_bus("Effects")
	SoundManager.set_default_ambient_sound_bus("Ambient")
	
	if hittable:
		setHealth(health)
	
	#if is_in_group("EnemyVehicle"):
		#SoundManager.play_ambient_sound(vehicleSound)

func setHealth(h):
	if hittable:
		healthBar = get_node("HealthBar").get_node("TextureProgressBar")
		healthBar.max_value = health
		healthBar.value = h
		damageTaken = health - h

##Returns the current health of the unit
func getHealth() -> float:
	return health - damageTaken

##A function for damaging this unit. Updates the health based on the attack damage and type provided in args.
func damage(args : AttackArguments):
	if hittable:
		onDamaged.emit(args)
		var currentDamage : float = args.attackDamage
		if args.attackType == AttackType.POISON:
			currentDamage *= (1 - poisonResistance)
			#Debug.Log("Poison damage reduced by ", 100 * poisonResistance, " percent.")
		
		if args.attackType == AttackType.MELEE:
			currentDamage *= (1 - meleeResistance)
			#Debug.Log("Melee damage reduced by ", 100 * meleeResistance, " percent.")
		
		damageTaken += currentDamage
		healthBar.value = health - damageTaken
		Debug.Log("Health bar value: ", healthBar.value)
		#Debug.LogSpace("Damage Taken " , currentDamage , name , " from " , args.from.name)
		#Debug.Log(name, " current health: ", health - damageTaken)
		check_death()
		if is_in_group("EnemyHuman"):
			var player:AudioStreamPlayer = SoundManager.play_sound(painSound)
			player.volume_db -= 0
		elif is_in_group("EnemyVehicle"):
			SoundManager.play_sound(vehicleDamage)

##Checks if the unit has died; if it has, then destroy it.
func check_death():
	if damageTaken >= health:
		die()
		if is_in_group("EnemyHuman"):
			SoundManager.play_sound(deathSound)
		elif is_in_group("EnemyVehicle"):
			SoundManager.play_sound(vehicleExplosion)
			#SoundManager.stop_ambient_sound(vehicleSound)

##Destroys the unit
func die():
	#queue_free()
	if isDead:
		return
	setIsDead()
	onDie.emit()
	var attackNode = find_child("Attack")
	if not attackNode:
		return
	for c in attackNode.StartedAttacking.get_connections():
		attackNode.StartedAttacking.disconnect(c["callable"])
		
	for c in attackNode.StoppedAttacking.get_connections():
		attackNode.StoppedAttacking.disconnect(c["callable"])
		
	for c in attackNode.AttackedEnemy.get_connections():
		attackNode.AttackedEnemy.disconnect(c["callable"])
	
	if onDie.get_connections().size() == 0:
		queue_free()

#its its own function so that we can tell if an attack should check for if its dead or not
func setIsDead():
	isDead = true

func stopAnimation():
	pass # Replace with function body.

func getRepairCost() -> float:
	return floor(damageTaken / health * cost)

func repairUnit(budget : float):
	var repairCost = getRepairCost()
	if repairCost <= budget:
		damageTaken = 0
		healthBar.value = health
		return repairCost
	else:
		return -1.0
