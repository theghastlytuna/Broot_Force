extends Node2D
class_name Unit

##The amount of health a unit has
@export var health : float

#this is the total amount of damage taken
#im doing it like this in case we want units to be able to heal themselves later, there has to be a way to have a units max health
var damageTaken : float

signal onDamaged(args)
signal onDie

func getHealth() -> float:
	return health - damageTaken

func damage(args : AttackArguments):
	onDamaged.emit(args)
	damageTaken += args.attackDamage
	Debug.LogSpace("Damage Taken " , str(args.attackDamage) , name)
	check_death()
	
func check_death():
	if damageTaken >= health:
		die()
		
func die():
	queue_free()

