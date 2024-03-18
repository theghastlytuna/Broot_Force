extends Node

var depthsCollected : Array[float]
var totalWater : float = 0
var waterPerRound : float = 0
var availableUnits : Array[int] = []


func _enter_tree() -> void:
	for unit in Unit.UnitType.keys():
		availableUnits.append(0)
	
