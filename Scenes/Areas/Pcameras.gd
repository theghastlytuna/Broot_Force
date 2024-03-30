extends Node2D

@export var pathFollower : PathFollow2D
@export var secondsToMove : float
var T : float
var move : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.onTowersPlaced.connect(goToGamepay)
	pathFollower.progress_ratio = 0
	pass # Replace with function body.

func goToGamepay():
	#tween to other camera
	move = true
	pass
	
func _process(delta: float) -> void:
	if not move:
		return
	T += delta/secondsToMove
	pathFollower.progress_ratio = ease(T,-3)
	if T >= 1:
		move = false
	pass
