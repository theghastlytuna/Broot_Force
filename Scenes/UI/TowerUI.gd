extends Panel

@export var towerResources : Array[Resource]
@export var freeTowers : bool = false
var nodeToPlaceTower : Node2D
var towerIndex : int = -1
var showing : bool = false

func _ready() -> void:
	visible = false
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
		$AnimationPlayer.queue("Hide")
		nodeToPlaceTower = null
		showing = false
		return
	
	visible = true
	if nodeToPlaceTower == null:
		$AnimationPlayer.queue("Show")
		
	nodeToPlaceTower = placement	
	
	
	for c in $TabContainer/BUILD/VBoxContainer.get_children():
		c.queue_free()
	for i in toShow:
		var newIcon = preload("res://Scenes/UI/TowerInfo.tscn").instantiate()
		newIcon.setIcon(i)
		$TabContainer/BUILD/VBoxContainer.add_child(newIcon)
		newIcon.onClicked.connect(towerClicked.bind(i))
		
	
	$TabContainer/BUILD/Build.text = "CLOSE"
	setBuildButtonColor(Color.WHITE)
	$TabContainer/BUILD/Health.visible = false
	$TabContainer/BUILD/Type.visible = false
	
	pass

func towerClicked(clickedType : Unit.TowerType):
	$TabContainer/BUILD/Health/Label.text = "HP: " + str(GameManager.towerHP(clickedType))
	#$Health/Label.add_theme_color_override("font_color",Color.RED)
	
	$TabContainer/BUILD/Type/Label.text = GameManager.towerPlacementType(clickedType)
	towerIndex = clickedType
	$TabContainer/BUILD/Build.text = "BUILD"
	setBuildButtonColor(Color.WEB_GREEN)
	$TabContainer/BUILD/Health.visible = true
	$TabContainer/BUILD/Type.visible = true
	pass
	
func confirmClicked():
	
	if towerIndex == -1 or nodeToPlaceTower == null:
		$AnimationPlayer.queue("Hide")
		showing = false
		nodeToPlaceTower = null
		towerIndex = -1
		return
	
	if not (GameManager.spendWater(GameManager.towerCost(towerIndex))) and not freeTowers:
		$TabContainer/BUILD/Build.text = "NOT_ENOUGH_MONEY"
		setBuildButtonColor(Color.RED)
		return
	nodeToPlaceTower.spawn_tower(towerResources[towerIndex].instantiate(),towerResources[towerIndex].resource_path)
	$AnimationPlayer.queue("Hide")
	showing = false
	nodeToPlaceTower = null
	towerIndex = -1
	
func setBuildButtonColor(c : Color):
	$TabContainer/BUILD/Build.add_theme_color_override("font_color",c)
	$TabContainer/BUILD/Build.add_theme_color_override("font_pressed_color",c)
	$TabContainer/BUILD/Build.add_theme_color_override("font_hover_color",c)
	$TabContainer/BUILD/Build.add_theme_color_override("font_focus_color",c)
