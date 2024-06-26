extends Control

var called : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.onRootPhaseEnd.connect(showResults)
	$PanelContainer.visible = false
	called = false
	
func showResults():
	if called:
		return
	called = true
	$AnimationPlayer.play("Show")
	var totalUnitsCollected : int
	for unit in GameManager.rootPhaseStats.availableUnits:
		totalUnitsCollected+=unit
	$PanelContainer/VBoxContainer/Label2.text = LocalizationManager.tr("ROOT_RESULTS").format({"Water":(GameManager.rootPhaseStats.waterToAddPerRound),"Unit":(totalUnitsCollected)})
	
	EventManager.rootStopMoving.emit()	
	$PanelContainer.visible = true
	
func goToGrowth():
	EventManager.onGrowthPhaseStart.emit()
	SoundManager.stop_all_ambient_sounds()
