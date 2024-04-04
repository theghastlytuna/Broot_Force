extends Control

var amountToClick : int = 0
var amountClicked : int = 0
const dirtSound: AudioStream =  preload("res://Sounds/SFX/dirt.mp3")
const tapSound: AudioStream =  preload("res://Sounds/UI/impact.mp3")
@export var particles : CPUParticles2D
@export var finale : CPUParticles2D
@export var wiggleTimer : Timer
@export var timesToWiggle : int = 4
@export var maxToWiggle : Vector2#spread in each direction
var timesWiggled : int = 0
var particleChildren : Array
var originalPosition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer.visible = false
	originalPosition = position	
	EventManager.onShowRockUI.connect(showUI)
	SoundManager.set_default_ambient_sound_bus("Ambient")
	SoundManager.set_default_sound_bus("Effects")
	particleChildren.append(particles)
	for i in 3:
		var newParticle = particles.duplicate()
		particles.get_parent().add_child(newParticle)
		particleChildren.append(newParticle)
	pass
	
func showUI(layer : int):
	amountClicked = 0
	$PanelContainer.visible = true
	layer+=1
	amountToClick = max(ceil(randi_range(layer*5,layer*7) * (1 - GameManager.getUpgradeAmount("STRENGTH"))), 1)
	$PanelContainer/VBoxContainer/Label3.text = LocalizationManager.tr("OBSTICLE_HIT_LEFT").format({"Number":(amountToClick-amountClicked)})
	EventManager.rootStopMoving.emit()
	timesWiggled = 0
	$PanelContainer/AnimationPlayer.play("Show")
	pass
	
func pressed():
	amountClicked +=1
	SoundManager.play_sound(tapSound, "Effects")
	$PanelContainer/VBoxContainer/Label3.text = LocalizationManager.tr("OBSTICLE_HIT_LEFT").format({"Number":(amountToClick-amountClicked)})
	
	if amountClicked >= amountToClick:
		$PanelContainer.visible = false
		EventManager.onRockUIEnd.emit()
		EventManager.rootStartMoving.emit()
		SoundManager.play_ambient_sound(dirtSound)
		finale.emitting = true
	else:
		wiggle()
		for p in particleChildren:
			if p.emitting:
				continue
			p.emitting = true
			break
		
	pass
	
func wiggle():
	wiggleTimer.paused = false
	wiggleTimer.start()
	pass
	
func wiggleTimerTimeout():
	position = originalPosition + Vector2(randf_range(-1,1)*maxToWiggle.x,randf_range(-1,1)*maxToWiggle.y)
	timesWiggled += 1
	if timesWiggled >= timesToWiggle:
		position = originalPosition
		wiggleTimer.stop()
		timesWiggled = 0
	pass
