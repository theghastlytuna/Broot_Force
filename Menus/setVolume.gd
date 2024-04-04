extends HSlider

func _ready():
	Debug.Log("Init music vol: ", SoundManager.get_music_volume())
	Debug.Log("Init ambient vol: ",SoundManager.get_ambient_sound_volume())
	Debug.Log("Init sound vol: ",SoundManager.get_sound_volume())


func _on_drag_ended(value_changed: bool) -> void:
	

	SoundManager.set_sound_volume(value)
	SoundManager.set_ambient_sound_volume(value)
	SoundManager.set_music_volume(value)
	
	Debug.Log("music vol: ", SoundManager.get_music_volume())
	Debug.Log("ambient vol: ",SoundManager.get_ambient_sound_volume())
	Debug.Log("sound vol: ",SoundManager.get_sound_volume())
	pass # Replace with function body.
