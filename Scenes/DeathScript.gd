extends Node2D

signal OnDeath

func killUnit():
	Debug.Log("DIED")
	OnDeath.emit()
	get_parent().queue_free()
