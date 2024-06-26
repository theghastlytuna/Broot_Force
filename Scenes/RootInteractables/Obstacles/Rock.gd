extends "res://Scripts/RootPhase/Interactable Scripts/InteractableBehaviour.gd"

func HitByRoot(area: Area2D):
	var layerNumber : int = floori(global_position.y/1500)
	EventManager.onShowRockUI.emit(layerNumber)
	EventManager.onHitRock.emit()
	
func _ready() -> void:
	EventManager.onSpawnedRock.emit(get_parent())
