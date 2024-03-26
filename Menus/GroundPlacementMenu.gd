extends PanelContainer

@export var tower_resources:Array[Resource]
var most_recent_parentclicked:Node2D
var open_menu = false
var towerIndex : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = false

# Cancel button function
func _on_texture_button_pressed():
	if open_menu:
		$AnimationPlayer.play("Hide")
		open_menu = false
		$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = false
	

# Node press function
func _on_button_land_clicked(to_parent_to):
	if !open_menu:
		$AnimationPlayer.play("Show")
		open_menu = true
	most_recent_parentclicked = to_parent_to

# Confirm button function
func _on_button_confirm():
	most_recent_parentclicked.spawn_tower(tower_resources[towerIndex].instantiate(),tower_resources[towerIndex].resource_path)
	Debug.Log("spawned tower")
	$AnimationPlayer.play("Hide")
	open_menu = false
	$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = false
	$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = false
	$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = false
	$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = false

# General tower button selection function
func _on_button_clicked(index_arg):
	towerIndex = index_arg
	
	match towerIndex:
		0:
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = true
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = false
			Debug.Log("text 1")
		1:
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = true
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = false
			Debug.Log("text 2")
		2:
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text0.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text1.visible = false
			$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/Text2.visible = true
			Debug.Log("text 3")
		
	$NinePatchRect/MarginContainer/VBoxContainer/Confirm.visible = true
