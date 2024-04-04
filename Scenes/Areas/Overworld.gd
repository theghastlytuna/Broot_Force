extends Node2D

func _enter_tree():
	EventManager.onGrowthPhaseEnd.connect(growthOver)
	GameManager.growthRounds += 1
	SaveManager.saveGame()
	SaveManager.loadData()
	Debug.Log("growth round ",GameManager.growthRounds)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func growthOver():
	SaveManager.saveGame()
	SaveManager.loadData()
	get_tree().change_scene_to_file("res://Scenes/UI/landscape_to_portrait.tscn")
