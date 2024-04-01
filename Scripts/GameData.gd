extends Resource
class_name GameData

@export var depthsCollected : Array[float]
@export var totalWater : float:
	get:
		Debug.Log("GET TOTAL_WATER:",totalWater)
		return totalWater
	set(value):
		Debug.Log("SET TOTAL_WATER:",value)
		totalWater = value
@export var waterPerRound : float:
	get:
		Debug.Log("GET WATER_PER_ROUND:",waterPerRound)
		return waterPerRound
	set(value):
		Debug.Log("SET WATER_PER_ROUND:",value)
		waterPerRound = value
@export var availableUnits : Array[int]
@export var placedTowers : Dictionary
@export var placedTowerHealth : Dictionary
@export var pastRoots : Dictionary
@export var growthRounds : int
@export var rootRounds : int
@export var rootUpgrades : Dictionary

