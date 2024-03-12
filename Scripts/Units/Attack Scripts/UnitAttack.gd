extends Node2D
class_name Attack

enum AttackType{
	MELEE,
	RANGED,
	VEHICLE,
	POISON
	}

var enemyBodies : Array[PhysicsBody2D]

var attackTimer : Timer

##Damage per attack
@export var attackDamage : float = 1

##The type of attack this is
@export var attackType : AttackType

##Amount of time in seconds to attack
@export var timePerAttack : float = 1

##Number of targets that one attack hits
@export var numberOfTargets : int = 1

##The group that this attack will exclusively attack
@export var groupToAttack : String

signal StartedAttacking
signal StoppedAttacking

# Called when the node enters the scene tree for the first time.
func _ready():
	attackTimer = Timer.new()
	attackTimer.wait_time = timePerAttack
	attackTimer.autostart = false
	attackTimer.stop()
	attackTimer.timeout.connect(attack)
	add_child(attackTimer)

func _on_attack_area_body_entered(body : PhysicsBody2D):
	if body.is_in_group(groupToAttack):
		if enemyBodies.size() == 0:
			attackTimer.start()
			StartedAttacking.emit()
		enemyBodies.append(body)

func _on_attack_area_body_exited(body : PhysicsBody2D):
	if body.is_in_group(groupToAttack):
		enemyBodies.erase(body)
		if enemyBodies.size() == 0:
			attackTimer.stop()
			StoppedAttacking.emit()

func _on_timer_timeout():
	attack()
	#print(enemyColliders[0].get_parent().getHealth())

func attack():
	var unitsAttacked : int = 0
	var attackArgs : AttackArguments = AttackArguments.new(attackDamage,get_parent(),attackType)
	while unitsAttacked < numberOfTargets && unitsAttacked < enemyBodies.size():
		enemyBodies[unitsAttacked].damage(attackArgs)
		unitsAttacked += 1
	Debug.Log("Attack done")
