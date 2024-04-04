extends Control



func _ready() -> void:
	EventManager.onWaterChanged.connect(setText)
	setText(GameManager.waterBank)

func setText(i):
	Debug.Log("d",i)
	$TextureRect/Label.text = str(i)

func _on_button_2_pressed() -> void:
	EventManager.onClickedOutsideUI.emit()
	pass # Replace with function body.

func setVisible(b):
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color.TRANSPARENT ,0.3)
