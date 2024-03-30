extends Control

@export var pathToScene : String
@export var setToLandscape = true

func _ready() -> void:
	if setToLandscape:
		GameManager.setLandscapeMode()
	else:
		GameManager.setPortraitMode()

func goToScene():
	get_tree().change_scene_to_file(pathToScene)
	
	pass
