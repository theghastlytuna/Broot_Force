extends Node2D

var currentRoundBudget : float
var maxUnitIndex : int = 0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var unitsToSpawn : Array[Object]
var unitSpawnTimer : Timer
var activated : bool = false

##The budget of the first round, each consecutive round has 20 percent more
##than the previous
@export var firstRoundBudget : float = 40
##Holds all of the enemy units
@export var enemyUnits : Array[CharacterBody2D]
##How long it takes to spawn all units in a round, in seconds
@export var spawnLength : float = 30
##Parent node to spawn units under
@export var unitParent : Node2D
##budget multiplier
@export var budgetFactor : float = 1.2
##the number of rounds until a new unit will spawn
@export var roundsPerNewUnit : int

signal FinishedSpawning()

# Called when the node enters the scene tree for the first time.
func _ready():
	currentRoundBudget = firstRoundBudget * pow(budgetFactor, GameManager.growthRounds - 1)
	Debug.Log("This round's budget: ", currentRoundBudget)
	maxUnitIndex = min(floori(GameManager.growthRounds/roundsPerNewUnit), 6)
	rng.randomize()
	
	var unitPicker : int = rng.randi_range(1, 3)
	
	var meleeBudget : float
	var rangedBudget : float
	var vehicleBudget : float
	
	var baseUnitType : String
	var extraUnitTypes : Array
	
	if unitPicker == 1:
		baseUnitType = "Melee"
		extraUnitTypes = ["Vehicle", "Ranged"]
		meleeBudget = currentRoundBudget * 0.5
		rangedBudget = currentRoundBudget * 0.25
		vehicleBudget = currentRoundBudget * 0.25
		
	elif unitPicker == 2:
		baseUnitType = "Ranged"
		extraUnitTypes = ["Vehicle", "Melee"]
		meleeBudget = currentRoundBudget * 0.25
		rangedBudget = currentRoundBudget * 0.5
		vehicleBudget = currentRoundBudget * 0.25
	else:
		baseUnitType = "Vehicle"
		extraUnitTypes = ["Ranged", "Melee"]
		meleeBudget = currentRoundBudget * 0.25
		rangedBudget = currentRoundBudget * 0.25
		vehicleBudget = currentRoundBudget * 0.5

	Debug.Log("Base unit type: " + baseUnitType + "Extra unit types: " + extraUnitTypes[0] + " " + extraUnitTypes[1])
	
	var currentIndex : int = maxUnitIndex
	while currentIndex >= 0:
		if enemyUnits[currentIndex].is_in_group("Vehicle") && \
		enemyUnits[currentIndex].cost <= vehicleBudget:
			unitsToSpawn.append(enemyUnits[currentIndex])
			vehicleBudget -= enemyUnits[currentIndex].cost
			Debug.Log("Added a vehicle")
		else:
			currentIndex -= 1
	
	Debug.Log("Finished vehicles")
	
	currentIndex = maxUnitIndex
	rangedBudget += vehicleBudget
	while currentIndex >= 0:
		if enemyUnits[currentIndex].is_in_group("Ranged") && \
		enemyUnits[currentIndex].cost <= rangedBudget:
			unitsToSpawn.append(enemyUnits[currentIndex])
			rangedBudget -= enemyUnits[currentIndex].cost
			Debug.Log("Added a ranged")
		else:
			currentIndex -= 1
	
	Debug.Log("Finished ranged")
	
	currentIndex = maxUnitIndex
	meleeBudget += rangedBudget
	while currentIndex >= 0:
		if enemyUnits[currentIndex].is_in_group("Melee") && \
		enemyUnits[currentIndex].cost <= meleeBudget:
			unitsToSpawn.append(enemyUnits[currentIndex])
			meleeBudget -= enemyUnits[currentIndex].cost
			Debug.Log("Added a melee")
		else:
			currentIndex -= 1
	Debug.Log("Finished melee")
	#var spawnLoopNum : int = 0
	#var budgetToSpend = currentRoundBudget * 0.5
	#while spawnLoopNum <= 2:
		#while currentIndex >= 0:
			#var currentIndex : int = maxUnitIndex
			#if spawnLoopNum == 0:
				#if enemyUnits[currentIndex].is_in_group("Vehicle") && \
				#enemyUnits[currentIndex].cost <= budgetToSpend:
					#unitsToSpawn.append(enemyUnits[currentIndex])
					#budgetToSpend -= enemyUnits[currentIndex].cost
					#Debug.Log("Found a " + baseUnitType)
				#else:
					#currentIndex -= 1
			#
			#elif spawnLoopNum == 1:
				#if enemyUnits[currentIndex].is_in_group(extraUnitTypes[0]) && \
				#enemyUnits[currentIndex].cost <= budgetToSpend:
					#unitsToSpawn.append(enemyUnits[currentIndex])
					#budgetToSpend -= enemyUnits[currentIndex].cost
					#Debug.Log("Found a " + extraUnitTypes[0])
				#else:
					#currentIndex -= 1
			#
			#else:
				#if enemyUnits[currentIndex].is_in_group(extraUnitTypes[1]) && \
				#enemyUnits[currentIndex].cost <= budgetToSpend:
					#unitsToSpawn.append(enemyUnits[currentIndex])
					#budgetToSpend -= enemyUnits[currentIndex].cost
					#Debug.Log("Found a " + extraUnitTypes[1])
				#else:
					#currentIndex -= 1
		#budgetToSpend += currentRoundBudget * 0.25
		#spawnLoopNum += 1
	unitSpawnTimer = Timer.new()
	add_child(unitSpawnTimer)
	unitSpawnTimer.wait_time = spawnLength / unitsToSpawn.size()
	unitSpawnTimer.timeout.connect(spawnUnit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if unitsToSpawn.size() == 0:
		unitSpawnTimer.stop()

func spawnUnit():
	rng.randomize()
	
	var index = rng.randi_range(0, unitsToSpawn.size() - 1)
	var newUnit = unitsToSpawn[index].duplicate()
	
	newUnit.position = position
	unitParent.add_child(newUnit)
	unitsToSpawn.remove_at(index)
	
	Debug.Log("Spawned: " + newUnit.name)
	
	if unitsToSpawn.size() == 0:
		FinishedSpawning.emit()


func _on_button_button_up():
	unitSpawnTimer.start()
