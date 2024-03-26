extends Control

var amountToClick : int = 0
var amountClicked : int = 0
const dirtSound: AudioStream =  preload("res://Sounds/SFX/dirt.mp3")
const tapSound: AudioStream =  preload("res://Sounds/UI/impact.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	EventManager.onShowRockUI.connect(showUI)
	SoundManager.set_default_ambient_sound_bus("Ambient")
	SoundManager.set_default_sound_bus("Effects")
	pass
	
func showUI(layer : int):
	amountClicked = 0
	visible = true
	layer+=1
	amountToClick = max(ceil(randi_range(layer*5,layer*7) * (1 - GameManager.getUpgradeAmount("Strength"))), 1)
	$VBoxContainer/Label3.text = LocalizationManager.tr("OBSTICLE_HIT_LEFT").format({"Number":(amountToClick-amountClicked)})
	EventManager.rootStopMoving.emit()
	pass
	
func pressed():
	amountClicked +=1
	SoundManager.play_sound(tapSound, "Effects")
	$VBoxContainer/Label3.text = LocalizationManager.tr("OBSTICLE_HIT_LEFT").format({"Number":(amountToClick-amountClicked)})
	if amountClicked >= amountToClick:
		visible = false
		EventManager.onRockUIEnd.emit()
		EventManager.rootStartMoving.emit()
		SoundManager.play_ambient_sound(dirtSound)
	pass
