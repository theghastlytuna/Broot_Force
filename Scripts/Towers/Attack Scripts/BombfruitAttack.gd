extends "res://Scripts/Units/Attack Scripts/UnitAttack.gd"

#var poisonCloud  = preload("res://Scenes/Units/TreeUnitsCanopy/bomberCloud.tscn")
#@export var poisonLocation : Node2D
@export var poisonNode : Node2D

func attack():
	super()
	poisonNode.startCloud()
