extends AnimationPlayer

@export var animationToPlay : String 

func playAnimation():
	play(animationToPlay)
	
func stopAnimation():
	seek(0,true)
	stop()
