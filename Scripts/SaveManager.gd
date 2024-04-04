extends Node

var saveData : GameData
var alwaysReset : bool = false
var existingData : bool = false

func resetData():
	saveData = GameData.new()
	saveGame()
	existingData = false

func saveGame():
	existingData = true
	if not saveData:
		resetData()
	var collectedUnits = get_tree().get_nodes_in_group("COLLECTED")
	for n in collectedUnits:
		saveData.depthsCollected.append(n.depth)
	collectedUnits.clear()
	saveData.availableUnits = GameManager.availableUnits
	saveData.waterToAddPerRound = GameManager.waterToAddPerRound
	saveData.waterBank = GameManager.waterBank

	saveData.placedTowers = GameManager.placedTowers
	saveData.placedTowerHealth = GameManager.placedTowersHealth
	saveData.pastRoots = GameManager.pastRoots
	saveData.growthRounds = GameManager.growthRounds
	saveData.rootRounds = GameManager.currentRootRound
	saveData.rootUpgrades = GameManager.rootUpgrades
	ResourceSaver.save(saveData,"user://Data.tres")

func startGame() -> void:
	#load data
	if alwaysReset:
		resetData()
		return
	loadData()
	
	
func loadData():
	if FileAccess.file_exists("user://Data.tres"):
		existingData = true
		saveData = load("user://Data.tres")
		GameManager.availableUnits = saveData.availableUnits
		GameManager.waterToAddPerRound = saveData.waterToAddPerRound
		GameManager.waterBank = saveData.waterBank
		GameManager.depthsCollected = saveData.depthsCollected
		GameManager.placedTowers = saveData.placedTowers 
		GameManager.placedTowersHealth = saveData.placedTowerHealth 
		GameManager.pastRoots = saveData.pastRoots
		GameManager.growthRounds = saveData.growthRounds
		GameManager.currentRootRound = saveData.rootRounds 
		GameManager.rootUpgrades = saveData.rootUpgrades
		if GameManager.rootUpgrades.size() == 0:
			GameManager.rootUpgrades = {"SPEED": 0,"TURNING": 0,"DURATION": 0,"STRENGTH": 0,"RESOURCE": 0}
		if GameManager.rootUpgrades.has("Speed"):
			GameManager.rootUpgrades = {"SPEED": 0,"TURNING": 0,"DURATION": 0,"STRENGTH": 0,"RESOURCE": 0}
	else:
		existingData = false
		saveData = GameData.new()
		saveData.availableUnits = [0, 0, 0, 0, 0, 0, 0]
		saveData.waterToAddPerRound = 0
		saveData.waterBank = 0
		saveData.depthsCollected = []
		saveData.placedTowers = {}
		saveData.placedTowerHealth = {}
		saveData.pastRoots = {}
		saveData.growthRounds = 0
		saveData.rootRounds = 0
		saveData.rootUpgrades = {"SPEED": 0,"TURNING": 0,"DURATION": 0,"STRENGTH": 0,"RESOURCE": 0}
		saveGame()
	pass
