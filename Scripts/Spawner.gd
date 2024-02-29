extends Node2D

var noiseX : FastNoiseLite
var noiseY : FastNoiseLite
@export var resourceDictionary : Dictionary#Vector2(min,max),Resource
@export var YSpread : float
#the vector2 will describe the range from which a resource can be spawned in from.
#for example, Vector2(0 (inclusive),5(inclusive) will spawn the object if the random % is between 0-5

func _ready():
	noiseX = FastNoiseLite.new()
	noiseX.seed = 0
	noiseX.noise_type = FastNoiseLite.TYPE_VALUE
	
	noiseY = FastNoiseLite.new()
	noiseY.noise_type = FastNoiseLite.TYPE_VALUE
	
	for i in range(1000):
		spawnObject(i)
	pass
	
func spawnObject(depth : float):
	#have 2 1D noises for spawning
	#one is sampled with the current depth, check if that value is the same as a resource
	#if it is, use the current depth as the seed for another 1D noise that will determine where on the Y axis the object will be spawned (a multiplier from 0-1 that will be multiplied by some distance value)
	var noiseValue : float = noiseX.get_noise_1d(depth)
	var percentNoiseValue : int = abs(floori(noiseValue*100))
	#print(percentNoiseValue)
	for vec in resourceDictionary.keys():
		if percentNoiseValue >= vec.x and percentNoiseValue <= vec.y:
			noiseY.seed = depth
			var noiseYValue : float = noiseY.get_noise_1d(depth)
			var yPosition : float = noiseYValue * YSpread
			print(Vector2(depth,yPosition))
			pass
			#make new noise and spawn at Y
		pass
	
