extends Node2D

## The Y-value height of each layer 
##(after the player travels this distance, the layer should swap to the next in the dictionary).
@export var layerHeight : float = 1500
@export var playerCam : Camera2D

##A nested array which holds arrays of info required for layer generation. Each inner array should hold:
##At index 0 - a string holding the path to the desired layer texture.
##At index 1 - a float representing a speed multiplier for the player's movement, where 1 means 100 percent speed.
##As layers get further down, speed multipliers should get smaller.
@export var layerArray : Array = [[]]

##A signal which emits when the player has changed layers. 
##Provides the speed multiplier for the layer that was entered
signal ChangedLayer(layerSpeedMultiplier : float)

#Index of latest layer rendered
var layerIndex : int = 0
#Index of layer the root is currently in
var rootCurrentLayer : int = 0
var changedLayer : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#Load in the first layer (there should always be at least one in the array
	MakeNewLayer(load(layerArray[0][0]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Once the player's camera gets close to reaching the edge of the latest rendered layer, render a new layer
	if (playerCam.position.y + playerCam.get_viewport_rect().size.y) >= (layerHeight * (layerIndex + 1)):
		layerIndex += 1
		EventManager.onEnterNewLayer.emit(layerIndex)
		#If there are more layer textures to render, grab the next one
		if layerArray.size() > layerIndex:
			MakeNewLayer(load(layerArray[layerIndex][0]))
		
		#Otherwise, just render the last texture again
		else:
			MakeNewLayer(load(layerArray[layerArray.size() - 1][0]))
	
	#If the player enters a new layer downwardsm then add one to layer
	if playerCam.position.y >= (layerHeight * (rootCurrentLayer + 1)):
		rootCurrentLayer += 1
		changedLayer = true
	#If the player enters a new layer upwards, then remove one from layer
	elif playerCam.position.y <= (layerHeight * (rootCurrentLayer)):
		rootCurrentLayer -= 1
		changedLayer = true
	
	#If we changed layers this frame, then emit with the current layer's speed multiplier
	if changedLayer:
		if layerArray.size() > rootCurrentLayer:
			ChangedLayer.emit(layerArray[rootCurrentLayer][1])
		else:
			ChangedLayer.emit(layerArray[layerArray.size() - 1][1])

##Function for rendering a new layer. Requires the texture to be rendered.
func MakeNewLayer(newTex : Resource):
	#Create a new Sprite3D, name it, set its texture
	var newLayer : Sprite2D = Sprite2D.new()
	newLayer.name = "Layer " + str(layerIndex)
	newLayer.texture = newTex
	#Enable texture repeating
	newLayer.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	#Set the texture's y-value to the middle of the layer
	newLayer.position.y = (layerIndex + 1) * layerHeight - (0.5 * layerHeight)
	#Enable regions and set the Rect2's region
	newLayer.region_enabled = true
	newLayer.region_rect = Rect2(0, 0, 5000, layerHeight)
	#Add this layer as a child to the backgroundmanager
	add_child(newLayer)
