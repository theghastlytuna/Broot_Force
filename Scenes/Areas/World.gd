extends Node2D
@export var oldRootHolder : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	showOtherRoots()
	EventManager.onRootPhaseStart.emit()
	EventManager.onGrowthPhaseStart.connect(goToOverworld)
	

func showOtherRoots():
	for i in GameManager.pastRoots.size():
		var vectorArray = GameManager.pastRoots[i]
		var oldRoot : Line2D = preload("res://Scenes/RootStuff/OldRoot.tscn").instantiate()
		
		for p in vectorArray:
			oldRoot.add_point(p)
			pass
		oldRootHolder.add_child(oldRoot)

func goToOverworld():
	GameManager.currentRootRound += 1
	get_tree().change_scene_to_file("res://Scenes/Areas/Overworld.tscn")
	pass
