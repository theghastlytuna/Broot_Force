extends Node2D
class_name Unit

##The amount of health a unit has
@export var health : float

#this is the total amount of damage taken
#im doing it like this in case we want units to be able to heal themselves later, there has to be a way to have a units max health
var damageTaken : float

##Emits when the unit is damaged
signal onDamaged(args)
##Emits when the unit dies (and is destroyed)
signal onDie

##Returns the current health of the unit
func getHealth() -> float:
	return health - damageTaken

##A function for damaging this unit. Updates the health based on the attack damage and type provided in args.
func damage(args : AttackArguments):
	onDamaged.emit(args)
	damageTaken += args.attackDamage
	Debug.LogSpace("Damage Taken " , str(args.attackDamage) , name , " from " , args.from.name)
	check_death()

##Checks if the unit has died; if it has, then destroy it.
func check_death():
	if damageTaken >= health:
		die()

##Destroys the unit
func die():
	queue_free()

func stopAnimation():
	pass # Replace with function body.
