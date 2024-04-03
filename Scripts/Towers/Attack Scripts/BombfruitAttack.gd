extends "res://Scripts/Units/Attack Scripts/UnitAttack.gd"

@export var initialDamage : float = 1
@export var poisonDamage : float = 1

@export var fruitBomb : Node2D
@export var poisonCloud : Node2D

func _ready():
	super()
	fruitBomb.damage = initialDamage
	poisonCloud.damage = poisonDamage
