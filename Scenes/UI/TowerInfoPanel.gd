extends Panel

signal onClicked

func setIcon(type : Unit.TowerType):
	var unitName: String = str(Unit.TowerType.keys()[type])
	$Title.text = unitName
	$Icon.texture = load("res://Art Assets/Textures/Icons/TowerIcons/" + unitName + ".png")
	$water/Cost.text = str(GameManager.towerCost(type))
	pass
	
func clicked():
	onClicked.emit()
