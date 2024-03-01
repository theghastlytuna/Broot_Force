extends Node2D

@export var walkSpeed : float = 100 #not actually speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_parent().set_axis_velocity(Vector2(walkSpeed,0))
	pass

