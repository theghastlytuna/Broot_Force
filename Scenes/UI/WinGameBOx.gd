extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	EventManager.GameWon.connect(playAnim,CONNECT_ONE_SHOT)
	pass # Replace with function body.

func playAnim():
	if visible:
		return
	visible = true
	$PanelContainer/AnimationPlayer.play("Show")



func _on_button_pressed() -> void:
	SaveManager.saveGame()
	SaveManager.loadData()
	
	get_tree().change_scene_to_file("res://Menus/startmenu.tscn")
	pass # Replace with function body.
