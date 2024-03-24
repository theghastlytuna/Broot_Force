extends Unit

func check_death():
	if damageTaken >= health:
		Debug.Log("Game over dude!")
