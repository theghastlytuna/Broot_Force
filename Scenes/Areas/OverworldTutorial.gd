extends Control

@export var tutorialText : Label
@export var tutorialContainer : Container
@export var exampleSprout : Control
@export var startButton : Button
@export var waterMeter : Control
var followingObject : Node2D

func _ready() -> void:
	#if GameManager.growthRounds == 0:
	startTutorial()

func setTutorialText(s : String, v : Vector2):
	tutorialText.text = s
	tutorialContainer.global_position = v
	pass
	
func followObject(node : Node, offset : Vector2 = Vector2.ZERO):
	if node == null:
		tutorialContainer.call_deferred("reparent",self)
		return
	tutorialContainer.call_deferred("reparent",node)
	tutorialContainer.global_position = node.global_position + offset

func startTutorial():
	setTutorialText("OVERWORLD_TUTORIAL_1",Vector2.ZERO)
	followObject(exampleSprout,Vector2(0,-tutorialText.size.y/2))
	EventManager.onGroundClicked.connect(clickedSprout)
	EventManager.onCanopyClicked.connect(clickedSprout)
	
	pass
	
func clickedSprout(arg1,arg2):
	setTutorialText("OVERWORLD_TUTORIAL_2",Vector2.ZERO)
	followObject(exampleSprout,Vector2(0,-tutorialText.size.y/2))
	EventManager.onGroundClicked.disconnect(clickedSprout)
	EventManager.onCanopyClicked.disconnect(clickedSprout)
	EventManager.onPlacedTower.connect(startRound)
	pass
	
func startRound():
	setTutorialText("OVERWORLD_TUTORIAL_3",Vector2.ZERO)
	followObject(startButton,Vector2((startButton.size.x/2) + (tutorialText.size.x/2) + 50,startButton.size.y/2))
