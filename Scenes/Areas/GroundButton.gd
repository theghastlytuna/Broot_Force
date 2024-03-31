extends Button

@export var parentnode:Node2D
signal land_clicked(to_parent_to)
var isVisible : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	parentnode.onTowerPlacedOnSlot.connect(setVisible)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setVisible(b : bool):
	#visible = !b
	disabled = b
	if !b:
		$TextureRect/AnimationPlayer.play("Sprout")
		$TextureRect/AnimationPlayer.queue("Bob")
		isVisible = true
	else:
		if isVisible:
			$TextureRect/AnimationPlayer.play("Retreat")
		isVisible = false
	

func _on_pressed():
	EventManager.onGroundClicked.emit([0,1,2],parentnode)
