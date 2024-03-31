extends Button

@export var parentnode:Node2D
signal land_clicked(to_parent_to)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	EventManager.onGroundClicked.emit([0,1,2],parentnode)
