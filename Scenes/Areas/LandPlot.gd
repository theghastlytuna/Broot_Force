extends Node2D

@export var towerIndex : int
var stashedTower : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.placedTowers.has(towerIndex):
		instantiate_tower(GameManager.placedTowers[towerIndex])
		
	#EventManager.onGrowthPhaseEnd.connect(setTowerHealth)
	pass # Replace with function body.


func _exit_tree() -> void:
	if not stashedTower:
		return
	GameManager.placedTowersHealth[towerIndex] = stashedTower.getHealth()

func instantiate_tower(path):
	spawn_tower(load(path).instantiate(),path)
	stashedTower.setHealth(GameManager.placedTowersHealth[towerIndex])
	#Debug.Log("set health to " + GameManager.placedTowersHealth[towerIndex])

func spawn_tower(tower, path):
	if get_child_count() > 0:
		for c in get_children():
			#TODO: give yourself some resources back?
			c.queue_free()
	add_child(tower)
	stashedTower = tower
	#$CanvasLayer/Button.visible = false
	#TODO: make its style completely invisible
	GameManager.placedTowers[towerIndex] = path
	
	var group : int = -1
	for i in range(7):
		if stashedTower.is_in_group(str(i)):
			group = i
			break
	
	GameManager.placedTowersType[group] += 0.2
