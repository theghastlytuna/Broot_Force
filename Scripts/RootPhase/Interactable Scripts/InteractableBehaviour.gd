extends Node2D

var active : bool = true

func HitByRoot(area: Area2D):
	Debug.Log("Hit an object: " + get_parent().get_groups()[0] + ", already been hit - " + str(!active))
	
