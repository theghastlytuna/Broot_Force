extends Resource
class_name GameData

@export var depthsCollected : Array[float]
@export var waterBank : float
@export var waterToAddPerRound : float
@export var availableUnits : Array[int] = [0,0,0,0,0,0,0]
@export var placedTowers : Dictionary
@export var placedTowerHealth : Dictionary
@export var pastRoots : Dictionary
@export var growthRounds : int
@export var rootRounds : int
@export var rootUpgrades : Dictionary
@export var ySeed : int

