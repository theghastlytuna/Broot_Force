extends "res://Scripts/RootPhase/Interactable Scripts/InteractableBehaviour.gd"

func HitByRoot(area: Area2D):
	if active:
		ResourceHolder.water += 1
		Debug.Log(ResourceHolder.water)
	super(area)

