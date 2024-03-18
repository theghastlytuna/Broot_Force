extends PanelContainer

@export var tower_resources:Array[Resource]
var most_recent_parentclicked:Node2D
var open_menu = false
var display_desc = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect/MarginContainer/VBoxContainer/Control/Confirm.visible = false
	$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/ThornwallText.visible = false
	pass # Replace with function body.

# Cancel button function
func _on_texture_button_pressed():
	#if open_menu:
	$AnimationPlayer.play("Hide")
	Debug.Log("I'm hiding")
	open_menu = false
	display_desc = false
	$NinePatchRect/MarginContainer/VBoxContainer/Control/Confirm.visible = false
	pass # Replace with function body.

# Node press function
func _on_button_land_clicked(to_parent_to):
	if !open_menu:
		$AnimationPlayer.play("Show")
		open_menu = true
	most_recent_parentclicked = to_parent_to
	pass # Replace with function body.

# Confirm button function
func _on_button_confirm(extra_arg_0):
	most_recent_parentclicked.spawn_tower(tower_resources[extra_arg_0].instantiate())
	Debug.Log("spawned tower")
	$NinePatchRect/MarginContainer/VBoxContainer/Control/Confirm.visible = false
	$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/ThornwallText.visible = false
	display_desc = false
	pass # Replace with function body.

# General tower button selection function
func _on_button_clicked():
	if !display_desc:
		display_desc = true
		
		$NinePatchRect/MarginContainer/VBoxContainer/Control/Confirm.visible = true
		$NinePatchRect/MarginContainer/VBoxContainer/TextureRect/ThornwallText.visible = true
	pass # Replace with function body.


