extends Unit

var hasDied : bool = false

func check_death():
	if damageTaken >= health and not hasDied:
		EventManager.GameLose.emit()
		Debug.Log("Game over dude!")
		hasDied = true
