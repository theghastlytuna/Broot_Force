extends Node2D



func _enter_tree():
	GameManager.growthRounds += 1
	GameManager.overworldNewRound()
	GameManager.currentRoundBudget = 500



func gameReady():
	#Debug.Log(AIManager.NN.predict(GameManager.placedTowersType))
	pass
