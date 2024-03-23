extends "res://Scripts/RootPhase/Interactable Scripts/InteractableBehaviour.gd"

@export var waterPerLayer : Array[Vector2]

func HitByRoot(area: Area2D):
	var layerNumber : int = floori(global_position.y/1500)
	#Debug.Log("LAYER",layerNumber)
	var water : int = randi_range(waterPerLayer[layerNumber].x,waterPerLayer[layerNumber].y)
	GameManager.waterPerRound += water	
	GameManager.rootPhaseStats.totalWater += water
	EventManager.onWaterCollected.emit()
	super(area)

