extends Node2D

var inputArray : Array = [
	[0.4,   0.2, 0.2, 0.2, 0.4, 0.4, 0 ],
	[0.2,   0,   0,   0,   0,   0,   0 ],
	[0, 0.2, 0,   0,   0,   0,   0 ],
	[0, 0,   0.2, 0,   0,   0,   0 ],
	[0, 0,   0,   0.2, 0,   0,   0 ],
	[0, 0,   0,   0,   0.2, 0,   0 ],
	[0, 0,   0,   0,   0,   0.2, 0 ],
	[0, 0,   0,   0,   0,   0,   0.2 ],
	[0.2,   0.2, 0,   0,   0,   0,   0 ],
	[0, 0.2, 0.2, 0,   0,   0,   0 ],
	[0, 0,   0.2, 0.2, 0,   0,   0 ],
	[0, 0,   0,   0.2, 0.2, 0,   0 ],
	[0, 0,   0,   0,   0.2, 0.2, 0 ],
	[0, 0,   0,   0,   0,   0.2, 0.2 ],
	[0.2, 0,   0.2, 0,   0,   0,   0 ],
	[0,   0.2, 0,   0.2, 0,   0,   0 ],
	[0,   0,  0.2, 0,  0.2, 0,   0 ],
	[0.2, 0,   0,   0.2, 0,   0,   0 ],
	[0,   0.2, 0,   0,   0.2, 0,   0 ],
	[0,   0,   0.2, 0,   0,   0.2, 0 ],
	[0.2, 0,   0,   0,   0.2, 0,   0 ],
	[0,   0.2, 0,   0,   0,   0.2, 0 ],
	[0,   0,   0.2, 0,   0,   0,   0.2 ],
	[0.2, 0,   0,   0,   0,   0.2, 0 ],
	[0,   0.2, 0,   0,   0,   0,   0.2 ],
	[0.2, 0,   0,   0,   0,   0,  0.2 ]
]

var outputArray : Array = [
	[0, 0, 0.5, 0, 0, 1, 0.25 ],
	[0, 0.25, 0, 0, 0.5, 0, 1 ],
	[0, 0, 0.5, 0.25, 0, 1, 0 ],
	[0, 0.25, 0, 0, 0.5, 0, 1 ],
	[0.25, 0, 0, 0.5, 0, 0, 1 ],
	[0, 0, 0.5, 0, 0, 1, 0.25 ],
	[0, 0, 0.5, 0.25, 0, 1, 0 ],
	[0.25, 0, 0, 0.5, 0, 0, 1 ],
	[0, 0, 0, 0, 0.25, 0.5, 1 ],
	[0, 0, 0, 0, 0.25, 0.5, 1 ],
	[0, 0, 0, 0.25, 0.5, 0, 1 ],
	[0, 0, 0.25, 0, 0, 1, 0.5 ],
	[0, 0, .5, 0, 0, 1, 0.25 ],
	[1, 0, 0, 0.25, 0, 0.5, 1 ],
	[0, 0.25, 0, 0, 0.5, 0, 1 ],
	[0, 0, 0.25, 1, 0, 0.5, 0 ],
	[0, 0, 0.5, 0, 0, 1, 0.25 ],
	[0, 0, 0, 0.5, 0.25, 0, 1 ],
	[0, 0, 0.5, 0, 0, 1, 0.25 ],
	[0, 0, 0, 0.25, 0, 0.5, 1 ],
	[0, 0, 0.25, 0, 0, 0.5, 1 ],
	[0, 0, 0.5, 0.25, 0, 1, 0 ],
	[0, 0, 0, 0.25, 0.5, 0, 1 ],
	[0, 0, 0, 0.25, 0, 0.5, 1 ],
	[0, 0, 0.25, 0, 0, 1, 0.5 ],
	[0, 0, 0, 0.5, 0.25, 0, 1 ]
]

func _enter_tree():
	GameManager.growthRounds += 1
	GameManager.overworldNewRound()

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.currentRoundBudget = 400
	Debug.Log("SETTING MONEY REMOVE LATER 400")
	return
	var newNN : NeuralNetwork = NeuralNetwork.new(7,15,7)
	newNN.learning_rate = 0.3
	
	for epoch in range(200):
		print(epoch)
		for i in inputArray.size():
			
			newNN.train(inputArray[i],outputArray[i])
			
	Debug.Log(newNN.predict(inputArray[0]))	
	Debug.Log(newNN.predict(inputArray[2]))	
	Debug.Log(newNN.predict(inputArray[inputArray.size()-1]))

	
	pass # Replace with function body.

func gameReady():
	pass
