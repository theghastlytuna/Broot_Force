extends Area2D




func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("COLLECTED"):
		return
	area.get_parent().add_to_group("COLLECTED")
	$"../../../SaveGame".saveGame()
	


