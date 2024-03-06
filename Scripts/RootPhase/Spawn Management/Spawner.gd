extends Node2D

var noiseX : FastNoiseLite
var noiseY : FastNoiseLite
@export var resourceDictionary : Dictionary#Vector2(min,max),Resource
#the vector2 will describe the range from which a resource can be spawned in from.
#for example, Vector2(0 (inclusive),5(inclusive) will spawn the object if the random % is between 0-5
@export var XSpread : float
@export var addingParent : Node2D


func _ready():
	noiseY = FastNoiseLite.new()
	noiseY.seed = 0
	noiseY.noise_type = FastNoiseLite.TYPE_VALUE
	noiseY.fractal_octaves = 4
	
	noiseX = FastNoiseLite.new()
	noiseX.noise_type = FastNoiseLite.TYPE_VALUE
	
	pass
	
func spawnObject(depth : float):
	var noiseValue : float = noiseY.get_noise_1d(depth)
	var percentNoiseValue : int = fposmod(noiseValue+1,1)*100 #random seeded value from 0-100
	
	#go through every resource and check if the percentNoiseValue is between the numbers in its vec2
	for vec in resourceDictionary.keys():
		if percentNoiseValue >= vec.x and percentNoiseValue <= vec.y:
			#if so, set the seed of noiseX to the depth so we can have a consistent seed for where on the X axis to place the object
			
			noiseX.seed = depth
			var noiseXValue : float = noiseX.get_noise_1d(depth)#get a new value from -1 - 1
			var xPosition : float = noiseXValue * XSpread# multiply it by Xspread to get the X position we will place this object
			
			#make a new node, set its position, and add it to a parent
			var newResource : Node2D = resourceDictionary[vec].instantiate()
			newResource.global_position = Vector2(xPosition,depth)
			addingParent.add_child(newResource)
			continue#dont keep iterating, once an object is spawned, any new objects would have the same X position so we will just leave it 

	
