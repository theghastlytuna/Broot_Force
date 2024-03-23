extends Node2D

var active : bool = true

func HitByRoot(area: Area2D):
	Debug.Log("Hit an object: " + get_parent().get_groups()[0] + ", already been hit - " + str(!active))
	var layerNumber : int = floori(global_position.y/1500)
	EventManager.onShowRockUI.emit(layerNumber)
