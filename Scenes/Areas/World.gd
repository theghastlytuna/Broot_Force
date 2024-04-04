extends Node2D
@export var oldRootHolder : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$SaveGame.startGame()
	SaveManager.loadData()
	Debug.Log("root round ",GameManager.currentRootRound)
	showOtherRoots()
	EventManager.onRootPhaseStart.emit()
	EventManager.onGrowthPhaseStart.connect(goToOverworld)
	GameManager.rootPhaseStats.availableUnits = [0,0,0,0,0,0,0]
	GameManager.setPortraitMode()
	

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
	
	GameManager.waterToAddPerRound += GameManager.rootPhaseStats.waterToAddPerRound
	GameManager.waterBank += GameManager.waterToAddPerRound
	GameManager.rootPhaseStats.waterToAddPerRound = 0
	
	
	SaveManager.saveGame()
	SaveManager.loadData()
	Debug.Log("next root round will be ",GameManager.currentRootRound)
	get_tree().change_scene_to_file("res://Scenes/UI/portrait_to_landscape.tscn")
	pass
