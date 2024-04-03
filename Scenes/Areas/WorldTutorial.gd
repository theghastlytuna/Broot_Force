extends Control

@export var tutorialText : Label
@export var tutorialContainer : Container
@export var movementNode:Control
@export var root : Node2D
var followingObject : Node2D

func _ready() -> void:
	startTutorial()

func setTutorialText(s : String, v : Vector2):
	tutorialText.text = s
	tutorialContainer.global_position = v
	pass
	
func followObject(node : Node2D, offset : Vector2 = Vector2.ZERO):
	if node == null:
		tutorialContainer.call_deferred("reparent",self)
		return
	tutorialContainer.call_deferred("reparent",node)
	tutorialContainer.global_position = node.global_position + offset

func startTutorial():
	EventManager.rootStopMoving.emit()
	#movementNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	movementNode.gui_input.connect(onMovementEntered)
	setTutorialText("WORLD_TUTORIAL_1",Vector2(get_viewport().size.x/2,(get_viewport().size.y/2)+300))
	movementNode.mouse_filter = Control.MOUSE_FILTER_STOP
	pass

func onMovementEntered(args):
	
	movementNode.gui_input.disconnect(onMovementEntered)
	movementNode.mouse_filter =Control.MOUSE_FILTER_IGNORE
	EventManager.rootStartMoving.emit()
	setTutorialText("",Vector2())
	#hit a rock
	EventManager.onSpawnedRock.connect(spawnedRock)
	pass
	
func spawnedRock(r : Node2D):
	#avoid rocks to save time
	setTutorialText("WORLD_TUTORIAL_2",Vector2.ZERO)
	followObject(r,Vector2(0,-tutorialText.size.y))
	EventManager.onSpawnedRock.disconnect(spawnedRock)
	EventManager.onSpawnedWater.connect(spawnedWater)
	
func spawnedWater(w : Node2D):
	#collect water to get extra resources!
	setTutorialText("WORLD_TUTORIAL_3",Vector2.ZERO)
	root.rootPositionOverride = w.global_position
	root.distanceOfAffect = root.global_position.distance_to(w.global_position)
	followObject(w,Vector2(0,-tutorialText.size.y))
	EventManager.onSpawnedWater.disconnect(spawnedWater)
	EventManager.onHitWater.connect(collectedWater)
	pass
	
func collectedWater():
	EventManager.onHitWater.disconnect(collectedWater)
	EventManager.onSpawnedUnit.connect(spawnUnit)
	root.rootPositionOverride = Vector2.ZERO
	root.distanceOfAffect = 0
	
func spawnUnit(u : Node2D):
	EventManager.onSpawnedUnit.disconnect(spawnUnit)
	EventManager.onHitUnit.connect(collectedUnit)
	setTutorialText("WORLD_TUTORIAL_4",Vector2.ZERO)
	root.rootPositionOverride = u.global_position
	root.distanceOfAffect = 1000
	followObject(u,Vector2(0,-tutorialText.size.y))
	pass

func collectedUnit():
	EventManager.onHitUnit.disconnect(collectedUnit)
	root.rootPositionOverride = Vector2.ZERO
	root.distanceOfAffect = 0
	pass
