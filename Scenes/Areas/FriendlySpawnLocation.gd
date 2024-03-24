extends Node2D

@export var allies : Array[Resource]

func _ready() -> void:
	EventManager.onAllySpawned.connect(spawnUnit)
	pass
	
func spawnUnit(type : int):
	var newUnit = load("res://Scenes/Units/TreeUnits/" + str(Unit.UnitType.keys()[type]) + ".tscn").instantiate()
	add_child(newUnit)
	pass
