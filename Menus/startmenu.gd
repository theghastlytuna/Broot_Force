extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.setLandscapeMode()
	$Control/Options.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_new_game():
	SaveManager.resetData()
	get_tree().change_scene_to_file("res://Scenes/Areas/World.tscn")

func _on_continue_game():
	SaveManager.loadData()
	if SaveManager.existingData:
		get_tree().change_scene_to_file("res://Scenes/Areas/World.tscn")

func _on_options_btn_pressed():
	Debug.Log("a")
	$Control/Options.visible = true
