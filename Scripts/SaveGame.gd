extends Node2D

var saveData : GameData
var alwaysReset : bool = false


func resetData():
	SaveManager.resetData()

func saveGame():
	SaveManager.saveGame()

func startGame() -> void:
	SaveManager.startGame()
	
	
func loadData():
	SaveManager.loadData()
