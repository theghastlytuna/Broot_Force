extends PanelContainer

@export var tower_resources:Array[Resource]
var most_recent_parentclicked:Node2D
var open_menu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_texture_button_pressed():
	#if open_menu:
	$AnimationPlayer.play("Hide")
	Debug.Log("I'm hiding")
	open_menu = false
	pass # Replace with function body.

func _on_button_land_clicked(to_parent_to):
	if !open_menu:
		$AnimationPlayer.play("Show")
		open_menu = true
	most_recent_parentclicked = to_parent_to
	pass # Replace with function body.

func _on_button_clicked(extra_arg_0):
	most_recent_parentclicked.spawn_tower(tower_resources[extra_arg_0].instantiate())
	Debug.Log("I'm thorning")
	
	pass # Replace with function body.
