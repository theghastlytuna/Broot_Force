extends PanelContainer
var numUnits : float
var unitType : Unit.UnitType

func showAlly(type : Unit.UnitType, amount : int):
	numUnits = amount
	unitType = type
	$VBoxContainer/TextureRect.texture = load("res://Art Assets/Textures/AllyIcons/" + str(Unit.UnitType.keys()[type] + ".png"))
	$VBoxContainer/Label.text = LocalizationManager.tr((Unit.UnitType.keys()[type])) + " : " + str(amount)
	pass
	

func useUnit():
	numUnits -= 1
	$VBoxContainer/Label.text = LocalizationManager.tr((Unit.UnitType.keys()[unitType])) + " : " + str(numUnits)
