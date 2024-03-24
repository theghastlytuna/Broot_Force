extends PanelContainer

func showAlly(type : Unit.UnitType, amount : int):
	$VBoxContainer/TextureRect.texture = load("res://Art Assets/Textures/Icons/UndeadUnits/" + str(Unit.UnitType.keys()[type] + ".png"))
	$VBoxContainer/Label.text = LocalizationManager.tr((Unit.UnitType.keys()[type])) + " : " + str(amount)
	pass
	
