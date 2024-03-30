extends HSlider


func _on_drag_ended(value_changed: bool) -> void:
	get_viewport().content_scale_factor = value
