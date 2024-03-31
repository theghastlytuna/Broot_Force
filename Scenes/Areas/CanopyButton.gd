extends Button

@export var parentnode:Node2D
signal canopy_clicked(to_parent_to)

# Called when the node enters the scene tree for the first time.
func _ready():
	parentnode.onTowerPlacedOnSlot.connect(setVisible)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setVisible(b : bool):
	visible = !b

func _on_pressed():
	EventManager.onCanopyClicked.emit([3,4,5,6],parentnode)
