extends MenuButton

signal popupItemPressed(i : int)

func buttonPressed():
	if get_popup().id_pressed.is_connected(pressed):
		return
	get_popup().id_pressed.connect(pressed)
	pass
	
func pressed(i : int):
	popupItemPressed.emit(i)
	get_popup().id_pressed.disconnect(pressed)
	pass
