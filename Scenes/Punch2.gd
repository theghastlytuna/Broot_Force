extends "res://Scenes/Punch.gd"

func _on_timer_timeout() -> void:
	print("A")
	super._on_timer_timeout()#super = base
	pass

