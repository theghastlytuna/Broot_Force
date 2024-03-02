extends Node2D

var enemyColliders : Array[Area2D]

var attackTimer : Timer

##Damage per attack
@export var attackDamage : float = 1

##Amount of time in seconds to attack
@export var timePerAttack : float = 1

##Number of targets that one attack hits
@export var numberOfTargets : int = 1

signal StartedAttacking
signal StoppedAttacking

# Called when the node enters the scene tree for the first time.
func _ready():
	attackTimer = get_child(0)
	attackTimer.wait_time = timePerAttack

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_attack_area_area_entered(area : Area2D):
	if area.get_parent().is_in_group("PlayerUnits"):
		if enemyColliders.size() == 0:
			attackTimer.start()
			StartedAttacking.emit()
		enemyColliders.append(area)

func _on_attack_area_area_exited(area : Area2D):
	if area.get_parent().is_in_group("PlayerUnits"):
		enemyColliders.erase(area)
		if enemyColliders.size() == 0:
			attackTimer.stop()
			StoppedAttacking.emit()

func _on_timer_timeout():
	_attack()
	print(enemyColliders[0].get_parent().health)

func _attack():
	var unitsAttacked : int = 0
	while unitsAttacked < numberOfTargets && unitsAttacked < enemyColliders.size():
		enemyColliders[unitsAttacked].get_parent().health -= attackDamage
		unitsAttacked += 1
