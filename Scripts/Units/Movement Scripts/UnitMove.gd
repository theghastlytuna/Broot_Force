extends Node2D

@export var moveSpeed : float = 100

var attacking : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !attacking:
		get_parent().linear_velocity.x = moveSpeed
	#Debug.Log(get_parent().linear_velocity.x)
	#print(get_parent().linear_velocity)

func _on_attack_started_attacking():
	Debug.Log("ENTERED AREA")
	get_parent().linear_velocity.x = 0
	attacking = true

func _on_attack_stopped_attacking():
	attacking = false
