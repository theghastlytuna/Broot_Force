extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.onRootPhaseEnd.connect(showResults)
	$PanelContainer.visible = false
	
func showResults():
	var totalUnitsCollected : int
	for unit in GameManager.availableUnits:
		totalUnitsCollected+=unit
	$PanelContainer/VBoxContainer/Label2.text = LocalizationManager.tr("ROOT_RESULTS").format({"Water":(GameManager.rootPhaseStats.waterPerRound),"Unit":(totalUnitsCollected)})
	$PanelContainer.visible = true
	EventManager.rootStopMoving.emit()	
	$AnimationPlayer.play("Show")
	
func goToGrowth():
	EventManager.onGrowthPhaseStart.emit()
	SoundManager.stop_all_ambient_sounds()
