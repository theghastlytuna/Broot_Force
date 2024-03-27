extends Node

var depthsCollected : Array[float]
var totalWater : float = 0
var currentRoundBudget : float = 0
var availableUnits : Array[int] = [0,0,0,0,0,0]
var placedTowers : Dictionary #number tower slot key, path resource
var placedTowersHealth : Dictionary #number tower slot key, float health
var growthRounds : int = 0
var pastRoots : Dictionary

var currentRootRound : int = 0

var desiredResolution : Vector2

##This holds how many upgrades have been purchased by the player, don't change these values
var rootUpgrades : Dictionary = {
	"Speed": 0,
	"Turning": 0,
	"Duration": 0,
	"Strength": 0,
	"Resource": 0
}

##This holds how much each upgrade boosts the root's characteristics (from 0-1, where 1 is a 100 percent increase. 
##Edit these to change how effective each upgrade is.
var valuesPerUpgrade : Dictionary = {
	"Speed": 0.1,
	"Turning": 0.1,
	"Duration": 0.2,
	"Strength": 0.2,
	"Resource": 0.05
}

##This holds the water cost to buy each type of root upgrade. 
##Edit these to change how much each upgrade costs.
var costsPerUpgrade : Dictionary = {
	"Speed": 20,
	"Turning": 25,
	"Duration": 15,
	"Strength": 10,
	"Resource": 25
}

#stuff for the current game
var rootPhaseStats : GameData = GameData.new()

var startedGame : bool = false

func _ready() -> void:#in landscape mode
	desiredResolution = get_viewport().size

func setLandscapeMode():
	get_viewport().size = Vector2(desiredResolution.y,desiredResolution.x)
	DisplayServer.screen_set_orientation(0)
	
func setPortraitMode():
	get_viewport().size = Vector2(desiredResolution.x,desiredResolution.y)
	DisplayServer.screen_set_orientation(1)

func upgradeRoot(upgrade : String):
	spendWater(costsPerUpgrade[upgrade])

func getUpgradeAmount(upgrade : String):
	return rootUpgrades[upgrade] * valuesPerUpgrade[upgrade]

func overworldNewRound():
	var outputWater = rootPhaseStats.waterPerRound
	totalWater += rootPhaseStats.waterPerRound
	rootPhaseStats.waterPerRound = 0
	currentRoundBudget = totalWater
	Debug.Log("Total water: ", totalWater)
	return outputWater

func spendWater(water : int):
	#Only spend water
	if water > currentRoundBudget:
		Debug.Log("Not enough money, bozo!!")
		return false
	else:
		Debug.Log("Budget before spending: ", currentRoundBudget)
		currentRoundBudget -= water
		Debug.Log("Budget after spending: ", currentRoundBudget)
		return true
