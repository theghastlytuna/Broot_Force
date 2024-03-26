extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.onWaterCollected.connect(setWaterText)
	setWaterText()
	pass # Replace with function body.

func setWaterText():
	text = tr("WATER_COLLECTED") + str(GameManager.rootPhaseStats.waterPerRound)
