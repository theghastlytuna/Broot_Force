extends Node2D

@export var towerIndex : int
var stashedTower : Node2D

signal onTowerPlacedOnSlot(placed:bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.placedTowers.has(towerIndex):
		instantiate_tower(GameManager.placedTowers[towerIndex])
		
	onTowerPlacedOnSlot.emit(false)
	#EventManager.onGrowthPhaseEnd.connect(setTowerHealth)
	pass # Replace with function body.


func _exit_tree() -> void:
	if not stashedTower:
		GameManager.placedTowersHealth.erase(towerIndex)
		GameManager.placedTowers.erase(towerIndex)
		return
	GameManager.placedTowersHealth[towerIndex] = stashedTower.getHealth()
	

func instantiate_tower(path):
	spawn_tower(load(path).instantiate(),path)
	if GameManager.placedTowersHealth.has(towerIndex):
		stashedTower.setHealth(GameManager.placedTowersHealth[towerIndex])
	#Debug.Log("set health to " + GameManager.placedTowersHealth[towerIndex])

func spawn_tower(tower, path):
	if stashedTower:
		stashedTower.onDie.emit()
			
	add_child(tower)
	stashedTower = tower
	onTowerPlacedOnSlot.emit(true)
	#$CanvasLayer/Button.visible = false
	#TODO: make its style completely invisible
	GameManager.placedTowers[towerIndex] = path
