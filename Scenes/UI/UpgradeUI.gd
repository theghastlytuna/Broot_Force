extends Control

@export var container : VBoxContainer
var upgradeToUpgrade : int
@export var confirmButton : Button
@export var animationPlayer : AnimationPlayer
@export var description : Label
@export var unlimitedUpgrades : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	setButtons()
	setConfirmButtonColour(Color.WHITE)
	confirmButton.text = "CLOSE"
	
	
func setButtons():
	for i in container.get_children():
		i.queue_free()
	for i in GameManager.UpgradeType.keys().size():
		var upgradeIcon = preload("res://Scenes/UI/UpgradePanel.tscn").instantiate()
		upgradeIcon.setIcon(i)
		container.add_child(upgradeIcon)
		upgradeIcon.onClicked.connect(selectUpgrade.bind(i))
		
func selectUpgrade(type : int):
	upgradeToUpgrade = type
	setConfirmButtonColour(Color.WEB_GREEN)
	confirmButton.text = "BUY"
	var upgradeType: String = str( GameManager.UpgradeType.keys()[upgradeToUpgrade])
	description.text = upgradeType + "_DESCRIPTION"
	pass
	
func confirmUpgrade():
	if upgradeToUpgrade < 0:
		animationPlayer.play("Close")
		return
	var upgradeType: String = str( GameManager.UpgradeType.keys()[upgradeToUpgrade])
	if GameManager.rootUpgrades[upgradeType] >= GameManager.maxRootUpgrades[upgradeType]:
		setConfirmButtonColour(Color.ORANGE_RED)
		confirmButton.text = "MAX_LEVEL"
		return
	if not GameManager.spendWater(GameManager.costsPerUpgrade[upgradeType]) and not unlimitedUpgrades:
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
