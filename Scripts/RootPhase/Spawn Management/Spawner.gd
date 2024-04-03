extends Node2D

var noiseX : FastNoiseLite
var noiseY : FastNoiseLite
##This is where you choose what will spawn, and with what frequency.
##The Dictionary's values are a Vector2, and a Resource.
##Everytime the spawner finds a place where a resource should spawn, it picks a random number between 0-100 to determine which resource will spawn in that location.
##The Vector2 respresents the range in which the random number must be between (min and max are inclusive) in order for that resource to spawn.
##The resource is the resource that will be instantiated in that location.
@export var layeredResourceDictionaries : Array #array of dictionaries with vec2 and resource key value pairs

var layerIndex : int = 0

##How many pixels the newly spawned resource can be from Y=0 (in both the positive and negative directions)
@export var XSpread : float
##The node that each newly spawned object will be parented to
@export var addingParent : Node2D

var spawnInterval : float

func _ready():
	noiseY = FastNoiseLite.new()
	noiseY.seed = 0
	noiseY.noise_type = FastNoiseLite.TYPE_VALUE
	noiseY.fractal_octaves = 4
	
	noiseX = FastNoiseLite.new()
	noiseX.noise_type = FastNoiseLite.TYPE_VALUE
	EventManager.onEnterNewLayer.connect(onNewLayer)
	spawnInFrame()
	pass
	
func spawnInFrame():
	return
	for i in range(spawnInterval*3,(get_viewport_rect().size.y/2) + spawnInterval,spawnInterval):
		spawnObject(i,get_viewport_rect().size.y/2)
		pass
	pass
	
func onNewLayer(i:int):
	layerIndex = i
	if layerIndex >= layeredResourceDictionaries.size():
		layerIndex = layeredResourceDictionaries.size()-1
	
	
func spawnObject(depth : float, desiredYOffset : float = 0):
	var noiseValue : float = noiseY.get_noise_1d(depth)
	var percentNoiseValue : int = fposmod(noiseValue+1,1)*100 #random seeded value from 0-100
	#go through every resource and check if the percentNoiseValue is between the numbers in its vec2
	var hadSpawned : bool = false
	for vec in layeredResourceDictionaries[layerIndex].keys():
		if percentNoiseValue >= vec.x and percentNoiseValue <= vec.y:
			#if so, set the seed of noiseX to the depth so we can have a consistent seed for where on the X axis to place the object
			hadSpawned = true
			noiseX.seed = depth
			var noiseXValue : float = noiseX.get_noise_1d(depth)#get a new value from -1 - 1
			var xPosition : float = noiseXValue * XSpread# multiply it by Xspread to get the X position we will place this object
			
			#make a new node, set its position, and add it to a parent
			var newResource : Node2D = layeredResourceDictionaries[layerIndex][vec].instantiate()
			newResource.global_position = Vector2(xPosition,depth+desiredYOffset)
			newResource.depth = depth
			if GameManager.depthsCollected.has(depth):
				newResource.add_to_group("COLLECTED")
				newResource.modulate = Color(0.5,0.5,0.5)
			addingParent.add_child(newResource)
			continue#dont keep iterating, once an object is spawned, any new objects would have the same X position so we will just leave it 
	if !hadSpawned:
		Debug.Log("SPAWNED NOTHING")
	
