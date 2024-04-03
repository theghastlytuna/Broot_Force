extends Node2D

func _enter_tree():
	GameManager.growthRounds += 20
	EventManager.onGrowthPhaseEnd.connect(growthOver)
	#GameManager.overworldNewRound()
	SaveManager.loadData()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func growthOver():
	get_tree().change_scene_to_file("res://Scenes/UI/landscape_to_portrait.tscn")
