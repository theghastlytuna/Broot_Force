extends Node2D


##I believe this is pixels/second?
@export var moveSpeed : float = 100

#Stores a boolean indicating whether the unit is currently attacking (and therefore shouldn't be moving)
var attacking : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#If the unit isn't attacking, then set its movespeed
	if !attacking:
		get_parent().velocity.x = moveSpeed
	#Move the unit based on its volecity
	get_parent().move_and_slide()

func _on_attack_started_attacking():
	#Debug.Log("ENTERED AREA")
	#Since it's attacking, don't let the unit move
	get_parent().velocity.x = 0
	attacking = true

func _on_attack_stopped_attacking():
	attacking = false
