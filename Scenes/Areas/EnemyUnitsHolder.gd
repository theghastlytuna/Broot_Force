extends Node2D

var finishedSpawning : bool = false
signal AllEnemiesKilled()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_children().size() == 0 && finishedSpawning:
		AllEnemiesKilled.emit()
		goToUnderworld()

func _on_enemy_spawner_finished_spawning():
	finishedSpawning = true

func goToUnderworld():
	EventManager.onGrowthPhaseEnd.emit()
