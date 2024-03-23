extends Node2D
class_name Unit

##The amount of health a unit has
@export var health : float
@export var type: UnitType
@export var cost: int

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
	UNDEAD_DINOSAUR,
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
	#if is_in_group("EnemyVehicle"):
		#SoundManager.play_ambient_sound(vehicleSound)

##Returns the current health of the unit
func getHealth() -> float:
	return health - damageTaken

##A function for damaging this unit. Updates the health based on the attack damage and type provided in args.
func damage(args : AttackArguments):
	onDamaged.emit(args)
	damageTaken += args.attackDamage
	Debug.LogSpace("Damage Taken " , str(args.attackDamage) , name , " from " , args.from.name)
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
	queue_free()

func stopAnimation():
	pass # Replace with function body.
