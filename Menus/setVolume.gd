extends HSlider




func _on_drag_ended(value_changed: bool) -> void:
	SoundManager.set_sound_volume(value)
	SoundManager.set_ambient_sound_volume(value)
	SoundManager.set_music_volume(value)
	pass # Replace with function body.
