extends "res://Scripts/Units/Attack Scripts/UnitAttack.gd"

@export var bombDamage : float = 1
@export var seedBomb : Node2D

func _ready():
	super()
	seedBomb.damage = bombDamage
