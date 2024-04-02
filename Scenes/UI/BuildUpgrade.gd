extends Panel



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.onClickedOutsideUI.connect(onOutsideClicked)
	EventManager.onTowersPlaced.connect(onOutsideClicked)
	pass # Replace with function body.

func onOutsideClicked():
	if $TabContainer/BUILD.showing:
		$AnimationPlayer.play("Hide")
		$TabContainer/BUILD.showing = false
		$TabContainer/BUILD.nodeToPlaceTower = null
	pass

