extends Node2D



func _enter_tree():
	GameManager.growthRounds += 1
	GameManager.overworldNewRound()



func gameReady():
	#Debug.Log(AIManager.NN.predict(GameManager.placedTowersType))
	pass
