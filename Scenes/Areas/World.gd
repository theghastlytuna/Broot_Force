extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.onRootPhaseStart.emit()
	EventManager.onGrowthPhaseStart.connect(goToOverworld)
	pass # Replace with function body.

func goToOverworld():
	#SceneTree.change_scene_to_file("res://Scenes/Areas/Overworld.tscn")
	pass
