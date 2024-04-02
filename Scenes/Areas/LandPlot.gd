extends Node2D

@export var towerIndex : int
var stashedTower : Node2D
var towerType = -1
signal onTowerPlacedOnSlot(placed:bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.placedTowers.has(towerIndex):
		instantiate_tower(GameManager.placedTowers[towerIndex])
		onTowerPlacedOnSlot.emit(true)
		return
	onTowerPlacedOnSlot.emit(false)
	#EventManager.onGrowthPhaseEnd.connect(setTowerHealth)
	pass # Replace with function body.


func _exit_tree() -> void:
	if not stashedTower:
		GameManager.placedTowersHealth.erase(towerIndex)
		GameManager.placedTowers.erase(towerIndex)
		return
	GameManager.placedTowersHealth[towerIndex] = stashedTower.getHealth()
	

func instantiate_tower(type):
	spawn_tower(type)
	if GameManager.placedTowersHealth.has(towerIndex):
		stashedTower.setHealth(GameManager.placedTowersHealth[towerIndex])
	#Debug.Log("set health to " + GameManager.placedTowersHealth[towerIndex])

func spawn_tower(type):
	if stashedTower:
		stashedTower.onDie.emit()
			
	stashedTower = GameManager.towerList[type].instantiate()
	add_child(stashedTower)
	onTowerPlacedOnSlot.emit(true)
	GameManager.placedTowers[towerIndex] = type
	towerType = type
