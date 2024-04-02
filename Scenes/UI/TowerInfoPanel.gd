extends Panel

signal onClicked

func setIcon(type : Unit.TowerType):
	var unitName: String = str(Unit.TowerType.keys()[type])
	setText(unitName)
	$Icon.texture = load("res://Art Assets/Textures/Icons/TowerIcons/" + unitName + ".png")
	setCost(GameManager.towerCost(type))
	pass
	
func clicked():
	onClicked.emit()
	
func setText(t):
	$Title.text = t
	
func setCost(f : float):
	$water/Cost.text = str(f)
