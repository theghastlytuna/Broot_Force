extends Control

@export var container : VBoxContainer
var upgradeToUpgrade : int
@export var confirmButton : Button
@export var animationPlayer : AnimationPlayer
@export var description : Label
@export var towerPanel : Control
@export var unlimitedUpgrades : bool = false
var towerSlot = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	setButtons()
	EventManager.onCanopyClicked.connect(setTower)
	EventManager.onGroundClicked.connect(setTower)
	setConfirmButtonColour(Color.WHITE)
	confirmButton.text = "CLOSE"
	
func setTower(towersToShow : Array, parent : Node2D):
	upgradeToUpgrade = -1
	if not parent.stashedTower:
		get_tree().call_group("Persist", "hide")
		return
	get_tree().call_group("Persist", "show")
	if parent.towerType >= 0:
		towerPanel.setIcon(parent.towerType)
		towerPanel.setCost(parent.stashedTower.getRepairCost())
		towerPanel.setText("REPAIR")
		if towerPanel.onClicked.is_connected(upgradeTower):
			towerPanel.onClicked.disconnect(upgradeTower)
		towerPanel.onClicked.connect(upgradeTower.bind(parent))
		
func upgradeTower(slot):
	towerSlot = slot
	setConfirmButtonColour(Color.WEB_GREEN)
	confirmButton.text = "UPGRADE"
	description.text = "TOWER_UPGRADE"
	pass
	
func setButtons():
	for i in container.get_children():
		if i.is_in_group("Persist"):
			continue
		i.queue_free()
	for i in GameManager.UpgradeType.keys().size():
		var upgradeIcon = preload("res://Scenes/UI/UpgradePanel.tscn").instantiate()
		upgradeIcon.setIcon(i)
		container.add_child(upgradeIcon)
		upgradeIcon.onClicked.connect(selectUpgrade.bind(i))
		
func selectUpgrade(type : int):
	towerSlot = null
	upgradeToUpgrade = type
	setConfirmButtonColour(Color.WEB_GREEN)
	confirmButton.text = "BUY"
	var upgradeType: String = str( GameManager.UpgradeType.keys()[upgradeToUpgrade])
	description.text = upgradeType + "_DESCRIPTION"
	pass
	
func confirmUpgrade():
	if upgradeToUpgrade <0:
		animationPlayer.play("Hide")
		return
		
	if towerSlot:
		#upgrade tower
		if towerSlot.stashedTower.getRepairCost() == 0:
			description.text = "CANT_HEAL_TOWER"
			setConfirmButtonColour(Color.RED)
			confirmButton.text = "TOWER_HP_FULL"
			return
		towerSlot.stashedTower.repairUnit(GameManager.totalWater)
		towerSlot = null
		return
	var upgradeType: String = str( GameManager.UpgradeType.keys()[upgradeToUpgrade])
	if GameManager.rootUpgrades[upgradeType] >= GameManager.maxRootUpgrades[upgradeType]:
		setConfirmButtonColour(Color.ORANGE_RED)
		confirmButton.text = "MAX_LEVEL"
		return
		
	var amountToSpend = GameManager.costsPerUpgrade[upgradeType]
	if unlimitedUpgrades:
		amountToSpend = 0
	if not GameManager.spendWater(amountToSpend):
		setConfirmButtonColour(Color.RED)
		confirmButton.text = "NOT_ENOUGH_MONEY"
		return
	GameManager.rootUpgrades[upgradeType] += 1
	setButtons()
	
func setConfirmButtonColour(c : Color):
	confirmButton.add_theme_color_override("font_color",c)
	confirmButton.add_theme_color_override("font_pressed_color",c)
	confirmButton.add_theme_color_override("font_hover_color",c)
	confirmButton.add_theme_color_override("font_focus_color",c)


