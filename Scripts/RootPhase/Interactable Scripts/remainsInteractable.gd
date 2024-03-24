extends "res://Scripts/RootPhase/Interactable Scripts/InteractableBehaviour.gd"

@export var unitType : Unit.UnitType

func HitByRoot(area: Area2D):
	GameManager.availableUnits[unitType] += 1
	super(area)
