extends "res://Scripts/RootPhase/Interactable Scripts/InteractableBehaviour.gd"

func HitByRoot(area: Area2D):
	if active:
		ResourceHolder.units += 1
		Debug.Log(ResourceHolder.units)
	super(area)
