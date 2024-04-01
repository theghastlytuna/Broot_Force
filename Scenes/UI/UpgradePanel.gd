extends Panel

signal onClicked

func setIcon(type : GameManager.UpgradeType):
	var upgradeType: String = str( GameManager.UpgradeType.keys()[type])
	$Title.text = upgradeType
	$Icon.texture = load("res://Art Assets/Textures/UpgradeIcons/" + upgradeType + ".png")
	$water/Cost.text = str(GameManager.costsPerUpgrade[upgradeType])
	$Level.text = str(GameManager.rootUpgrades[upgradeType]) + "/" + str(GameManager.maxRootUpgrades[upgradeType])
	pass
	
func clicked():
	onClicked.emit()

