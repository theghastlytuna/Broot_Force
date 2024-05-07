extends Control

@export var towerResources : Array[Resource]
@export var animationPlayer : AnimationPlayer
@export var type : Control
@export var health : Control
@export var confirm : Button
@export var container : VBoxContainer
@export var freeTowers : bool = false
@export var topParent : Control
var nodeToPlaceTower : Node2D
var towerIndex : int = -1
var showing : bool = false

func _ready() -> void:
	freeTowers = GameManager.freeTowers
	topParent.visible = false
	EventManager.onCanopyClicked.connect(showTowers)
	EventManager.onGroundClicked.connect(showTowers)
	var index = 0
	for t in towerResources:
		var newTower = t.instantiate()
		GameManager.towerCosts.append(0)
		GameManager.towerHPs.append(0)
		GameManager.towerCosts[index] = (newTower.cost)
		GameManager.towerHPs[index] = (newTower.health)
		index+=1
		pass

func showTowers(toShow : Array, placement : Node2D):
	towerIndex = -1
	#shows the tower type in the array toShow
	showing = true
	if placement == nodeToPlaceTower && showing:
		animationPlayer.queue("Hide")
		nodeToPlaceTower = null
		showing = false
		return
	
	topParent.visible = true
	if nodeToPlaceTower == null:
		animationPlayer.queue("Show")
		
	nodeToPlaceTower = placement	
	
	
	for c in container.get_children():
		c.queue_free()
	for i in toShow:
		var newIcon = preload("res://Scenes/UI/TowerInfo.tscn").instantiate()
		newIcon.setIcon(i)
		container.add_child(newIcon)
		newIcon.onClicked.connect(towerClicked.bind(i))
		
	
	confirm.text = "CLOSE"
	setBuildButtonColor(Color.WHITE)
	health.visible = false
	type.visible = false
	
	pass

func towerClicked(clickedType : Unit.TowerType):
	health.text = "HP: " + str(GameManager.towerHP(clickedType))
	#$Health/Label.add_theme_color_override("font_color",Color.RED)
	
	type.text = GameManager.towerPlacementType(clickedType)
	towerIndex = clickedType
	confirm.text = "BUILD"
	setBuildButtonColor(Color.WEB_GREEN)
	health.visible = true
	type.visible = true
	EventManager.onSelectedTowerToPlace.emit()
	pass
	
func confirmClicked():
	if not showing:
		return
	if towerIndex == -1 or nodeToPlaceTower == null:
		animationPlayer.queue("Hide")
		showing = false
		nodeToPlaceTower = null
		towerIndex = -1
		return
	
	var waterToSpend = GameManager.towerCost(towerIndex)
	if freeTowers:
		waterToSpend = 0
	if not (GameManager.spendWater(waterToSpend)):
		confirm.text = "NOT_ENOUGH_MONEY"
		setBuildButtonColor(Color.RED)
		return
	nodeToPlaceTower.spawn_tower(towerIndex)
	animationPlayer.queue("Hide")
	showing = false
	nodeToPlaceTower = null
	towerIndex = -1
	EventManager.onPlacedTower.emit()
	
func setBuildButtonColor(c : Color):
	confirm.add_theme_color_override("font_color",c)
	confirm.add_theme_color_override("font_pressed_color",c)
	confirm.add_theme_color_override("font_hover_color",c)
	confirm.add_theme_color_override("font_focus_color",c)
