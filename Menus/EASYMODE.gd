extends CheckBox


func _toggled(toggled_on):
	GameManager.freeTowers = toggled_on
