extends PanelContainer

@export var tower_resources:Array[Resource]
var most_recent_parentclicked:Node2D
var open_menu = false
var towerIndex : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = false

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		pass
	pass
	

# Cancel button function
func _on_texture_button_pressed():
	if open_menu:
		$AnimationPlayer.play("Hide")
		open_menu = false
		$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = false
	

# Node press function
func _on_button_canopy_clicked(to_parent_to):
	if !open_menu:
		$AnimationPlayer.play("Show")
		open_menu = true
	most_recent_parentclicked = to_parent_to

# Confirm button function
func _on_button_confirm():
	var newTower = tower_resources[towerIndex].instantiate()
	Debug.Log("Cost of tower: ", newTower.cost)
	if (GameManager.spendWater(newTower.cost)):
		most_recent_parentclicked.spawn_tower(newTower,tower_resources[towerIndex].resource_path)
		Debug.Log("spawned tower")
		$AnimationPlayer.play("Hide")
		open_menu = false
		$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = false
		$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = false
		$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = false
		$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = false
		$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text3.visible = false
	else:
		newTower.queue_free()

# General tower button selection function
func _on_button_clicked(index_arg):
	towerIndex = index_arg
	
	match towerIndex:
		0:
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = true
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text3.visible = false
		
		1:
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = true
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text3.visible = false
		
		2:
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = true
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text3.visible = false
		
		3:
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text3.visible = true
		
	$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = true


