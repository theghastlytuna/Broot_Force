extends HBoxContainer

var thisRoundUnits : Array[int]
var allButtons : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index : int = 0
	thisRoundUnits = GameManager.availableUnits
	for unitAmt in GameManager.availableUnits:
		if unitAmt > 0:
			var newChild = preload("res://Scenes/UI/AllySpawnButton.tscn").instantiate()
			newChild.showAlly(index,unitAmt)
			add_child(newChild)			
			newChild.find_child("Button").pressed.connect(clicked.bind(index))
			allButtons.append(newChild)
		index+=1
			
func clicked(typeToSpawn : int):
	if thisRoundUnits[typeToSpawn] > 0:
		EventManager.onAllySpawned.emit(typeToSpawn)
		thisRoundUnits[typeToSpawn] -= 1
		for buttonObject in allButtons:
			if buttonObject.unitType == typeToSpawn:
				buttonObject.useUnit()
	pass

