extends Unit

func check_death():
	if damageTaken >= health:
		EventManager.GameLose.emit()
		Debug.Log("Game over dude!")
