extends Node

var NN : NeuralNetwork = NeuralNetwork.new(7,15,7)

var inputArray : Array = [
	[0.4,   0.2, 0.2, 0.2, 0.4, 0.4, 0 ],
	[0, 0.2, 0,   0,   0,   0,   0 ],
	[0.2,   0,   0,   0,   0,   0,   0 ],
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
	[0, 0, 0.5, 0.25, 0, 1, 0 ],
	[0, 0.25, 0, 0, 0.5, 0, 1 ],
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

func _ready():
	return
	NN.learning_rate = 0.3
	
	for epoch in range(200):
		print(epoch)
		for i in inputArray.size():
			
			NN.train(inputArray[i],outputArray[i])
			


	Debug.Log(NN.predict(inputArray[0]))	
	Debug.Log(NN.predict(inputArray[1]))

	pass # Replace with function body.
