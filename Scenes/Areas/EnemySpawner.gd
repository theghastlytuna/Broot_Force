extends Node2D

var currentRoundBudget : float
var maxUnitIndex : int = 0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var unitsToSpawn : Array[Object]
var unitSpawnTimer : Timer
var activated : bool = false
var startedSpawning : bool = false

##The budget of the first round, each consecutive round has 20 percent more
##than the previous
@export var firstRoundBudget : float = 40
##Holds all of the enemy units
@export var enemyUnits : Array[CharacterBody2D]
##How long it takes to spawn all units in a round, in seconds
@export var spawnLength : float = 20
##Parent node to spawn units under
@export var unitParent : Node2D

var unitCosts : Dictionary

signal FinishedSpawning()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var Uindex = 0
	#for u in enemyUnits:
		#unitCosts[Uindex] = u.cost
		#Uindex+=1
	#
	#var AIArray = AIManager.NN.predict(GameManager.placedTowersType)
	#Debug.Log(AIArray)
	#AIArray.sort_custom(sort_ascending)
	#var confidence : Dictionary
	#
	#for i in AIArray.size():
		#confidence[AIArray[i]] = i
	#
	#Debug.Log(AIArray)
#
	#while currentRoundBudget >= 10:
		#for i in AIArray:
			#var unitIndex = confidence[i]
			#Debug.LogSpace("unit index",i," unit confidence",confidence[i],"current budget",currentRoundBudget)
			#if currentRoundBudget >= unitCosts[unitIndex]:
				#unitsToSpawn.append(enemyUnits[unitIndex])
				#currentRoundBudget -= unitCosts[unitIndex]
				#Debug.LogSpace("SPAWNED    unit index",i," unit confidence",confidence[i],"current budget",currentRoundBudget)
				#break

func sort_ascending(a, b):#ignore the title
	if a > b:
		return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if startedSpawning && unitsToSpawn.size() == 0:
		unitSpawnTimer.stop()

func spawnUnit():
	rng.randomize()
	Debug.Log("current budget: ", currentRoundBudget)
	var index = rng.randi_range(0, unitsToSpawn.size() - 1)
	var newUnit = unitsToSpawn[index].duplicate()
	
	newUnit.position = position
	unitParent.add_child(newUnit)
	unitsToSpawn.remove_at(index)
	
	Debug.Log("Spawned: " + newUnit.name)
	
	if unitsToSpawn.size() == 0:
		FinishedSpawning.emit()


func _on_button_button_up():
	currentRoundBudget = firstRoundBudget * pow(1.2, GameManager.growthRounds - 1)
	Debug.Log("This round's budget: ", currentRoundBudget)
	
	var confidenceDict : Dictionary
	var AIArray = AIManager.NN.predict(GameManager.placedTowersType)
	Debug.Log("Pre-sorting confidences: ", AIArray)
	
	for ind in AIArray.size():
		confidenceDict[AIArray[ind]] = ind
	AIArray.sort_custom(sort_ascending)
	Debug.Log("Post-sorting confidences: ", AIArray)
	
	while currentRoundBudget >= 10:
		for confidence in AIArray:
			var unitToSpawn = enemyUnits[confidenceDict[confidence]]
			var confidenceIndex = AIArray.find(confidence)
			#Debug.Log("Confidence index: ", confidenceIndex)
			
			if unitToSpawn.cost <= currentRoundBudget:
				rng.randomize()
				Debug.Log("Budget before spawning: ", currentRoundBudget)
				
				if rng.randi_range(1, 10) <= 3 && confidenceIndex != AIArray.size() - 1:
					var newUnitToSpawn
					for i in range(confidenceIndex + 1, AIArray.size()):
						newUnitToSpawn = enemyUnits[confidenceDict[AIArray[i]]]
						if newUnitToSpawn.cost <= currentRoundBudget:
							Debug.Log("Whoops! Spawned the wrong unit. Meant to spawn: ", unitToSpawn, " but now spawning: ", newUnitToSpawn)
							unitToSpawn = newUnitToSpawn
							break
 
				unitsToSpawn.append(unitToSpawn)
				currentRoundBudget -= unitToSpawn.cost
				Debug.Log("Budget after spawning: ", currentRoundBudget, " Unit spawned: ", unitToSpawn.name)
				break
	startedSpawning = true
	unitSpawnTimer = Timer.new()
	add_child(unitSpawnTimer)
	unitSpawnTimer.wait_time = spawnLength / unitsToSpawn.size()
	unitSpawnTimer.timeout.connect(spawnUnit)
	unitSpawnTimer.start()
