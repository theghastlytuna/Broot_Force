extends Node2D

func _enter_tree():
	GameManager.growthRounds += 1
	GameManager.overworldNewRound()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func gameReady():
	pass
