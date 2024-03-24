extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index : int = 0
	for unitAmt in GameManager.availableUnits:
		if unitAmt > 0:
			var newChild = preload("res://Scenes/UI/AllySpawnButton.tscn").instantiate()
			newChild.showAlly(index,unitAmt)
			add_child(newChild)			
			newChild.find_child("Button").pressed.connect(clicked.bind(index))
		index+=1
			
func clicked(typeToSpawn : int):
	EventManager.onAllySpawned.emit(typeToSpawn)
	pass

