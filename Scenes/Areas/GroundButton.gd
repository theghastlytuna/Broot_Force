extends Button

@export var parentnode:Node2D
signal land_clicked(to_parent_to)
var isVisible : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	isVisible = true
	parentnode.onTowerPlacedOnSlot.connect(setVisible)
	if GameManager.growthRounds == 1:
		$TextureRect/TextureRect2.visible = true
		$TextureRect/TextureRect2/AnimationPlayer.play("Spin")
	else:
		$TextureRect/TextureRect2.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setVisible(b : bool):
	#visible = !b
	#disabled = b
	if !b:
		$TextureRect/AnimationPlayer.play("Sprout")
		$TextureRect/AnimationPlayer.queue("Bob")
		isVisible = true
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		if isVisible:
			$TextureRect/AnimationPlayer.play("Retreat")
		isVisible = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	

func _on_pressed():
	Debug.Log("sdf")
	EventManager.onGroundClicked.emit([0,1,2],parentnode)
