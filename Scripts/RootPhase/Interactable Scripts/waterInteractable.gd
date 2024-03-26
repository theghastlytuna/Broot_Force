extends "res://Scripts/RootPhase/Interactable Scripts/InteractableBehaviour.gd"

@export var waterPerLayer : Array[Vector2]

func HitByRoot(area: Area2D):
	var layerNumber : int = floori(global_position.y/1500)
	#Debug.Log("LAYER",layerNumber)
	var water : int = ceil(randi_range(waterPerLayer[layerNumber].x,waterPerLayer[layerNumber].y) * \
		(1 + GameManager.getUpgradeAmount("Resource")))
	#GameManager.waterPerRound += water	
	GameManager.rootPhaseStats.waterPerRound += water
	EventManager.onWaterCollected.emit()
	super(area)

