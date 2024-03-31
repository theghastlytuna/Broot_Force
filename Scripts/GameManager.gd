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

var usingMobile : bool = true

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

var screenDimensions : Vector2 = Vector2(1280,720)#landscape

#stuff for the current game
var rootPhaseStats : GameData = GameData.new()

var startedGame : bool = false

func _ready() -> void:#in landscape mode
	desiredResolution = get_viewport().size

func setLandscapeMode():
	if not usingMobile:
		return
	var screenSize = DisplayServer.screen_get_size()
	#get_viewport().size = Vector2(desiredResolution.x,desiredResolution.y)
	#get_viewport().get_window().content_scale_factor = 2.5
	DisplayServer.screen_set_orientation(0)
	
func setPortraitMode():
	if not usingMobile:
		return
	var screenSize = DisplayServer.screen_get_size()
	#get_viewport().size = Vector2(desiredResolution.y,desiredResolution.x)
	#get_viewport().get_window().content_scale_factor = 2.5
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

func towerCost(type : Unit.TowerType):
	#THORN_WALL,
	#FLYTRAP_CLUSTER,
	#TOXIC_BLOOM,
	#THORN_VINES,
	#SEED_BOMBER,
	#BOMBER_FRUIT,
	#SPORE_SPRAYER
	return [5,12,9,19,29,16,24][type]#JORDAN WHAT ARE THESE PRICES?!?!?!
	
func towerPlacementType(type : Unit.TowerType):
	return ["GROUND","GROUND","GROUND","CANOPY","CANOPY","CANOPY","CANOPY"][type]
	
func towerHP(type : Unit.TowerType):
	return [250,200,150,250,200,1500,250][type]#some prices are fake
	pass

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
