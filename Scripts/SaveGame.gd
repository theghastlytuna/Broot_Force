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
	ResourceSaver.save(saveData,"user://Data.tres")

func _enter_tree() -> void:
	#load data
	loadData()
	
func loadData():
	if FileAccess.file_exists("user://Data.tres"):
		saveData = load("user://Data.tres")
		Debug.Log(saveData.depthsCollected)
	pass
