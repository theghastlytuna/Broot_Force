extends Node2D

var currentRoundBudget : float
var maxUnitIndex : int = 0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var unitsToSpawn : Array[Object]

##The budget of the first round, each consecutive round has 20 percent more
##than the previous
@export var firstRoundBudget : float = 40
##Holds all of the enemy units
@export var enemyUnits : Array[CharacterBody2D]
##How long it takes to spawn all units in a round, in seconds
@export var spawnLength : float = 30


# Called when the node enters the scene tree for the first time.
func _ready():
	currentRoundBudget = firstRoundBudget * pow(1.2, GameManager.growthRounds - 1)
	rng.randomize()
	
	var unitPicker : int = rng.randi_range(1, 3)
	var baseUnitType : String
	var extraUnitTypes : Array
	
	if unitPicker == 1:
		baseUnitType = "Melee"
		extraUnitTypes = ["Vehicle", "Ranged"]
	elif unitPicker == 2:
		baseUnitType = "Ranged"
		extraUnitTypes = ["Vehicle", "Melee"]
	else:
		baseUnitType = "Vehicle"
		extraUnitTypes = ["Ranged", "Melee"]
	
	var spawnLoopNum : int = 0
	while spawnLoopNum <= 2:
		var currentIndex : int = maxUnitIndex
		while currentIndex >= 0:
			if spawnLoopNum == 0:
				pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
