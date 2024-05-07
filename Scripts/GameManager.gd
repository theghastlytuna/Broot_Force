extends Node

var depthsCollected : Array[float]
#every round, waterToAddPerRound adds the rootPhaseStats.waterPerRound to itself, then we add waterToAddPerRound to waterBank to get the total amount of water the player can spend that round
#this is done in world.gd in the goToOverworld function
var waterBank : float = 0:
	get:
		return waterBank
	set(value):
		EventManager.onWaterChanged.emit(value)
		waterBank = value

var waterToAddPerRound : float = 0

var availableUnits : Array[int] = [0,0,0,0,0,0]
var placedTowers : Dictionary #number tower slot key, path resource
var placedTowersHealth : Dictionary #number tower slot key, float health
var s : Dictionary #number tower slot key, int type #this method is so stupid
var growthRounds : int = 0
var pastRoots : Dictionary
var towerList : Array = [
	preload("res://Scenes/Units/TreeUnitsGround/thorn_wall.tscn"),
	preload("res://Scenes/Units/TreeUnitsGround/flytrapCluster.tscn"),
	preload("res://Scenes/Units/TreeUnitsGround/toxicBloom.tscn"),
	preload("res://Scenes/Units/TreeUnitsCanopy/thornVines.tscn"),
	preload("res://Scenes/Units/TreeUnitsCanopy/seedBomber.tscn"),
	preload("res://Scenes/Units/TreeUnitsCanopy/bomberFruit.tscn"),
	preload("res://Scenes/Units/TreeUnitsCanopy/sporeSprayer.tscn")
	
	
	
]

var ySeed : int
var EnemyRoundsToAdd : int
var freeTowers : bool = false

#THORN_WALL,
	#FLYTRAP_CLUSTER,
	#TOXIC_BLOOM,
	#THORN_VINES,
	#SEED_BOMBER,
	#BOMBER_FRUIT,
	#SPORE_SPRAYER
var currentRootRound : int = 0

var desiredResolution : Vector2

var usingMobile : bool = true

##This holds how many upgrades have been purchased by the player, don't change these values
var rootUpgrades : Dictionary = {
	"SPEED": 0,
	"TURNING": 0,
	"DURATION": 0,
	"STRENGTH": 0,
	"RESOURCE": 0
}

##This is the maximum number of upgrades the player can make per type
var maxRootUpgrades : Dictionary = {
	"SPEED": 5,
	"TURNING": 3,
	"DURATION": 5,
	"STRENGTH": 3,
	"RESOURCE": 5
}

##This holds how much each upgrade boosts the root's characteristics (from 0-1, where 1 is a 100 percent increase. 
##Edit these to change how effective each upgrade is.
var valuesPerUpgrade : Dictionary = {
	"SPEED": 0.3,
	"TURNING": 0.1,
	"DURATION": 0.2,
	"STRENGTH": 0.2,
	"RESOURCE": 0.05
}

##This holds the water cost to buy each type of root upgrade. 
##Edit these to change how much each upgrade costs.
var costsPerUpgrade : Dictionary = {
	"SPEED": 20,
	"TURNING": 25,
	"DURATION": 15,
	"STRENGTH": 10,
	"RESOURCE": 25
}

enum UpgradeType{
		SPEED,
		TURNING,
		DURATION,
		STRENGTH,
		RESOURCE
	}

var screenDimensions : Vector2 = Vector2(1280,720)#landscape

#stuff for the current game
var rootPhaseStats : GameData = GameData.new()

var startedGame : bool = false
var towerCosts : Array#the array of towers is in the TowerUI script in the overworld
var towerType : Array
var towerHPs : Array

func _ready() -> void:#in landscape mode
	desiredResolution = get_viewport().size

func setLandscapeMode():
	DisplayServer.screen_set_orientation(0)
	if not usingMobile:
		return
	var screenSize = DisplayServer.screen_get_size()
	var newRes = Vector2i(desiredResolution.x,desiredResolution.y)
	#get_viewport().size = newRes
	#DisplayServer.window_set_size(newRes)
	
	get_viewport().get_window().content_scale_factor = 1
	
	
func setPortraitMode():
	DisplayServer.screen_set_orientation(1)
	if not usingMobile:
		return
	var screenSize = DisplayServer.screen_get_size()
	var newRes = Vector2i(desiredResolution.y,desiredResolution.x)
	
	#get_viewport().size = newRes
	#DisplayServer.window_set_size(newRes)
	get_viewport().get_window().content_scale_factor = 2
	

func upgradeRoot(upgrade : String):
	spendWater(costsPerUpgrade[upgrade])

func getUpgradeAmount(upgrade : String):
	return rootUpgrades[upgrade] * valuesPerUpgrade[upgrade]

func towerCost(type : Unit.TowerType):
	#THORN_WALL,
	#FLYTRAP_CLUSTER,
	#TOXIC_BLOOM,
	#THORN_VINES,
	#SEED_BOMBER,
	#BOMBER_FRUIT,
	#SPORE_SPRAYER
	return towerCosts[type]
	
func towerPlacementType(type : Unit.TowerType):
	return ["GROUND","GROUND","GROUND","CANOPY","CANOPY","CANOPY","CANOPY"][type]
	
func towerHP(type : Unit.TowerType):
	return towerHPs[type]#some prices are fake
	pass

func spendWater(water : int):
	#Only spend water
	if water > waterBank:
		Debug.Log("Not enough money, bozo!!")
		return false
	else:
		Debug.Log("bank before spending: ", waterBank)
		waterBank -= water
		Debug.Log("bank after spending: ", waterBank)
		return true
