extends Node2D

@export var lifetime : float = 2
@export var cloudSprite : Sprite2D
@export var attackNode : Node2D

var lifeTimer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#Set up the timer that keeps track of the cloud's lifetime
	lifeTimer.wait_time = lifetime + 0.1
	lifeTimer.autostart = false
	#The lifetime timer should be connected to stopCloud so that the 
	#poison attack is disabled once its life is done
	lifeTimer.timeout.connect(stopCloud)
	add_child(lifeTimer)
	#Make sure the cloud is off by default
	stopCloud()

## Function for enabling the poison cloud. The poison cloud automatically disables its attack 
## once its lifetime duration is complete 
func startCloud():
	Debug.Log("Attack enabled for cloud")
	#Enable the attack node, start the timer, make the poison sprite visible
	attackNode.enableAttack(true)
	lifeTimer.start()
	cloudSprite.visible = true

func stopCloud():
	Debug.Log("Attack DISABLED for cloud")
	#Disable the attack node, stop the timer, hide the poison sprite
	attackNode.enableAttack(false)
	lifeTimer.stop()
	#cloudSprite.visible = false
