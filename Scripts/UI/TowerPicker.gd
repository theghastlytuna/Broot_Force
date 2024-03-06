extends Control

@export var placeToPutTower : Node2D
@export var towerResource : Array[Resource]

func clicked(i : int):
	Debug.Log(i)
	var newTower = towerResource[i].instantiate()
	placeToPutTower.add_child(newTower)
