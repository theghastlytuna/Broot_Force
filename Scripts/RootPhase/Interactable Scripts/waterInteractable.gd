extends "res://Scripts/RootPhase/Interactable Scripts/InteractableBehaviour.gd"

@export var waterPerLayer : Array[Vector2]

func HitByRoot(area: Area2D):
	var layerNumber : int = floori(global_position.y/1500)
	#Debug.Log("LAYER",layerNumber)
	var water : int = ceil(randi_range(waterPerLayer[layerNumber].x,waterPerLayer[layerNumber].y) * \
		(1 + GameManager.getUpgradeAmount("RESOURCE")))
	#GameManager.waterPerRound += water	
	GameManager.rootPhaseStats.waterPerRound += water
	EventManager.onWaterCollected.emit()
	EventManager.onHitWater.emit()
	super(area)
	
func _ready() -> void:
	EventManager.onSpawnedWater.emit(get_parent())

