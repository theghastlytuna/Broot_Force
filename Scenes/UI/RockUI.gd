extends Control

var amountToClick : int = 0
var amountClicked : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	EventManager.onShowRockUI.connect(showUI)
	pass
	
func showUI(layer : int):
	amountClicked = 0
	visible = true
	layer+=1
	amountToClick = randi_range(layer*5,layer*7)
	$VBoxContainer/Label3.text = LocalizationManager.tr("OBSTICLE_HIT_LEFT").format({"Number":(amountToClick-amountClicked)})
	EventManager.rootStopMoving.emit()
	pass
	
func pressed():
	amountClicked +=1
	$VBoxContainer/Label3.text = LocalizationManager.tr("OBSTICLE_HIT_LEFT").format({"Number":(amountToClick-amountClicked)})
	if amountClicked >= amountToClick:
		visible = false
		EventManager.onRockUIEnd.emit()
		EventManager.rootStartMoving.emit()
	pass