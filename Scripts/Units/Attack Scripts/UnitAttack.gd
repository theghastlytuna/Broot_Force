extends Node2D
class_name Attack

const axeSound: AudioStream = preload("res://Sounds/SFX/wood cut.mp3")
const shotgunSound: AudioStream = preload("res://Sounds/SFX/shotgun.mp3")
const damageSound: AudioStream = preload("res://Sounds/SFX/wood cut.mp3")
const heavyDamageSound: AudioStream = preload("res://Sounds/SFX/tree damage.mp3")

enum AttackType{
	MELEE,
	RANGED,
	VEHICLE,
	POISON
	}

var enemyBodies : Array[PhysicsBody2D]

var attackTimer : Timer
var postAttackTimer : Timer

##Damage per attack
@export var attackDamage : float = 1

##The type of attack this is
@export var attackType : AttackType

##Amount of time in seconds needed to attack
@export var timeToAttack : float = 1

##Amount of time in seconds needed after attacking before starting attack timer again
@export var timeAfterAttack : float = 0

##Number of targets that one attack hits
@export var numberOfTargets : int = 1

##The group that this attack will exclusively attack
@export var groupToAttack : String

##If true, only attacks once and must be set to attacking to attack again
@export var oneShot : bool = false

#Keeps track of if the unit's attack is enabled
var attackEnabled : bool = true

#Keeps track of if the unit is currently in the attack phase
var isAttacking : bool = false

##Emits when the unit first starts attacking (typically when a unit first enters its attack range)
signal StartedAttacking

##Emits when the unit stops attacking (typically when the last unit leaves its attack range)
signal StoppedAttacking

signal AttackedEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	#Set up the attack timer so that it shares its duration with the attack speed
	attackTimer = Timer.new()
	attackTimer.wait_time = timeToAttack
	attackTimer.autostart = false
	attackTimer.one_shot = true
	attackTimer.stop()
	#Connect the timer's timeout to the attack method, so that the unit attacks at the proper attack speed
	attackTimer.timeout.connect(attack)
	add_child(attackTimer)
	
	postAttackTimer = Timer.new()
	postAttackTimer.wait_time = timeAfterAttack
	postAttackTimer.autostart = false
	postAttackTimer.one_shot = true
	postAttackTimer.stop()
	add_child(postAttackTimer)
	
	if timeToAttack <= 0.05:
		attackTimer.wait_time = 0.05
		postAttackTimer.wait_time -= 0.05
	elif timeAfterAttack <= 0.05:
		attackTimer.wait_time = timeToAttack - 0.05
		postAttackTimer.wait_time = 0.05
	else:
		attackTimer.wait_time = timeToAttack
		postAttackTimer.wait_time = timeAfterAttack
	
	attackTimer.timeout.connect(postAttackTimer.start)
	postAttackTimer.timeout.connect(attackTimer.start)
	
	SoundManager.set_default_sound_bus("Effects")

func _on_attack_area_body_entered(body : PhysicsBody2D):
	
	#If the detected body is in the target group
	if body.is_in_group(groupToAttack):
		Debug.Log(get_parent().name + " area entered")
		#If the unit isn't already attacking and attacking is enabled
		if !isAttacking && attackEnabled:
			#Set attacking to true, start the timer, emit the signal
			Debug.Log(get_parent().name + "started attacking")
			isAttacking = true
			attackTimer.start()
			StartedAttacking.emit()
		#Add the body to the end of the array of bodies being attacked
		enemyBodies.append(body)

func _on_attack_area_body_exited(body : PhysicsBody2D):
	#If the detected body is in the target group
	if body.is_in_group(groupToAttack):
		#Remove the body from the target bodies array
		enemyBodies.erase(body)
		#If the array is empty after removing the body
		if enemyBodies.size() == 0:
			#Nobody left to attack, so stop attacking, stop the timer, emit the signal
			isAttacking = false
			attackTimer.stop()
			postAttackTimer.stop()
			StoppedAttacking.emit()

func _on_timer_timeout():
	if get_parent().has_method("setIsDead"):
		if get_parent().isDead:
			return
	attack()
	#print(enemyColliders[0].get_parent().getHealth())

##Attack method which attacks the proper number of units (based on numberOfTargets) within 
##the array of bodies within the unit's attack range
func attack():
	var unitsAttacked : int = 0
	#Create an AttackArguments variable which holds the unit's attack damage, type, and the name of the unit
	var attackArgs : AttackArguments = AttackArguments.new(attackDamage,get_parent(),attackType)
	#Use a while loop to attack the correct number of units (maximum = numberOfTargets)
	while unitsAttacked < numberOfTargets && unitsAttacked < enemyBodies.size():
		enemyBodies[unitsAttacked].damage(attackArgs)
		unitsAttacked += 1
	
	AttackedEnemy.emit()
	
	if oneShot:
		enableAttack(false)
	
	if get_parent().is_in_group("EnemyUnits"):
		if attackType == AttackType.MELEE:
			SoundManager.play_sound(axeSound)
		elif attackType == AttackType.RANGED:
			SoundManager.play_sound(shotgunSound)
		elif attackType == AttackType.VEHICLE:
			SoundManager.play_sound(heavyDamageSound)
	#Debug.Log("Attack done")

##Method used for enablind and disabling this unit's ability to attack.
##A unit handles its own attack loop by default, this method should only be used for special units
##which need special activation/deactivation.
func enableAttack(attacking : bool):
	attackEnabled = attacking
	#If we just disabled attacking, make sure the attacking stops
	if !attackEnabled:
		isAttacking = false
		attackTimer.stop()
		StoppedAttacking.emit()
	#If we just enabled attacking, make sure the attacking starts
	elif enemyBodies.size() > 0:
		isAttacking = true;
		attackTimer.start()
		StartedAttacking.emit()

func testDebug():
	Debug.Log("post attack timer started")
