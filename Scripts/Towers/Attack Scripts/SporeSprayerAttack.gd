extends "res://Scripts/Units/Attack Scripts/UnitAttack.gd"

#var poisonCloud  = preload("res://Scenes/Units/TreeUnitsCanopy/bomberCloud.tscn")
#@export var poisonLocation : Node2D
@export var poisonNode : Node2D
@export var minCloudSpawn : Node2D
@export var maxCloudSpawn : Node2D

var leftExtent : float
var rightExtent : float
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	super()

func attack():
	super()
	randomize()
	Debug.Log("poison sprayer attacked*******")
	poisonNode.position.x = rng.randf_range(minCloudSpawn.position.x, maxCloudSpawn.position.x)
	poisonNode.startCloud()
