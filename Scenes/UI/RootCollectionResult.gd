extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.onRootPhaseEnd.connect(showResults)
	visible = false
	
func showResults():
	var totalUnitsCollected : int
	for unit in GameManager.availableUnits:
		totalUnitsCollected+=unit
	$VBoxContainer/Label2.text = LocalizationManager.tr("ROOT_RESULTS").format({"Water":(GameManager.rootPhaseStats.waterPerRound),"Unit":(totalUnitsCollected)})
	visible = true
	EventManager.rootStopMoving.emit()	
	
func goToGrowth():
	EventManager.onGrowthPhaseStart.emit()
	SoundManager.stop_all_ambient_sounds()
