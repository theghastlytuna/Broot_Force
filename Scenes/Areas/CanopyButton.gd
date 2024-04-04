extends Button

@export var parentnode:Node2D
signal canopy_clicked(to_parent_to)
var isVisible : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	isVisible = true
	parentnode.onTowerPlacedOnSlot.connect(setVisible)
	if GameManager.growthRounds == 1:
		$Control/TextureRect/TextureRect2.visible = true
		$Control/TextureRect/TextureRect2/AnimationPlayer.play("Spin")
	else:
		$Control/TextureRect/TextureRect2.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setVisible(b : bool):
	#disabled = b
	if !b:
		$Control/TextureRect/AnimationPlayer.play("Sprout")
		$Control/TextureRect/AnimationPlayer.queue("Bob")
		isVisible = true
		mouse_filter = Control.MOUSE_FILTER_PASS
	else :
		if isVisible:
			$Control/TextureRect/AnimationPlayer.play("Retreat")
		isVisible = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_pressed():
	EventManager.onCanopyClicked.emit([3,4,5,6],parentnode)
