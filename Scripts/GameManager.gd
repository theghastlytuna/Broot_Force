extends Node

var depthsCollected : Array[float]
var totalWater : float = 0
var waterPerRound : float = 0
var availableUnits : Array[int] = [0,0,0,0,0,0]
var pastRoots : Dictionary

var currentRootRound : int = 0

var desiredResolution : Vector2

#stuff for the current game
var rootPhaseStats : GameData = GameData.new()

func _ready() -> void:#in landscape mode
	desiredResolution = get_viewport().size

func setLandscapeMode():
	get_viewport().size = Vector2(desiredResolution.y,desiredResolution.x)
	DisplayServer.screen_set_orientation(0)
	
func setPortraitMode():
	get_viewport().size = Vector2(desiredResolution.x,desiredResolution.y)
	DisplayServer.screen_set_orientation(1)
	

	

	
	
