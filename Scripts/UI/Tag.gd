class_name Tag
extends PanelContainer

@export var color: Color
@export var tag: String

@onready var text_l: Label = $Text


func _ready() -> void:
	pass


func set_tag(_tag: String, _color: Color) -> void:
	var new_style = get_theme_stylebox("panel").duplicate()
	new_style.bg_color = _color
	add_theme_stylebox_override("panel", new_style)
	text_l.text = _tag
	name = _tag
