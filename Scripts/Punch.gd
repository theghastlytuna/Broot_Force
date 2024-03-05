extends Node2D

var collidingAreas : Array[Area2D]

@export var punchDamage : float = 10

func _on_attack_radius_area_entered(area: Area2D) -> void:
	if collidingAreas.size() == 0:
		$Timer.start()
	collidingAreas.append(area)
	pass # Replace with function body.



#TODO: move the attack to its own function attack()
func _on_timer_timeout() -> void:
		
	for a in collidingAreas:
		#print(a.get_parent().health)
		a.get_parent().health -= punchDamage
		#print(a.get_parent().health)
	pass # Replace with function body.


func _on_attack_radius_area_exited(area: Area2D) -> void:
	collidingAreas.erase(area)
	if collidingAreas.size() == 0:
		$Timer.stop()
	pass # Replace with function body.
