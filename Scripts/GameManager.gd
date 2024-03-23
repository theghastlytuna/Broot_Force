extends Node

var depthsCollected : Array[float]
var totalWater : float = 0
var waterPerRound : float = 0
var availableUnits : Array[int] = [0,0,0,0,0,0]

#stuff for the current game
var rootPhaseStats : GameData = GameData.new()
	
