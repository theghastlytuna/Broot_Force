extends Node2D

var saveData : GameData

func resetData():
	saveData = GameData.new()
	saveGame()

func saveGame():
	var collectedUnits = get_tree().get_nodes_in_group("COLLECTED")
	for n in collectedUnits:
		saveData.depthsCollected.append(n.global_position.y)
		Debug.Log(n.name)
	saveData.availableUnits = GameManager.availableUnits
	saveData.waterPerRound = GameManager.waterPerRound
	saveData.totalWater = GameManager.totalWater
	saveData.depthsCollected = GameManager.depthsCollected
	ResourceSaver.save(saveData,"user://Data.tres")

func _enter_tree() -> void:
	#load data
	loadData()
	
func loadData():
	if FileAccess.file_exists("user://Data.tres"):
		saveData = load("user://Data.tres")
		GameManager.availableUnits = saveData.availableUnits
		GameManager.waterPerRound = saveData.waterPerRound
		GameManager.totalWater = saveData.totalWater
		GameManager.depthsCollected = saveData.depthsCollected
	else:
		saveData = GameData.new()
		saveData.availableUnits = []
		saveData.waterPerRound = 0
		saveData.totalWater = 0
		saveData.depthsCollected = []
		saveGame()
	pass
