extends Control

@export var menu_size = 0.3
@export var lerp_speed = 0.2

var _open_menu = true
var _left_anchor = Vector2(1-menu_size,1) #0.7 anchor, right to left
var _right_anchor = Vector2(1+menu_size,1) 
var _target_anchor = _left_anchor #open menu anchor

func _ready():
	pass

func _process(delta):
	anchor_left = lerp(anchor_left, _target_anchor.x, lerp_speed)
	anchor_right = lerp(anchor_right, _target_anchor.y, lerp_speed)
	#print(_target_anchor)
	pass

func _on_texture_button_pressed():
	if !_open_menu:
		_target_anchor = _left_anchor
	else:
		_target_anchor = _right_anchor
	_open_menu = !_open_menu
	pass # Replace with function body.
