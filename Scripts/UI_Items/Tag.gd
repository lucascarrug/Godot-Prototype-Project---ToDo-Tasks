class_name Tag
extends PanelContainer

const STYLEBOX_KEY: String = "panel"

@export var color: Color
@export var tag: String

@onready var text_label: Label = $Text


func set_tag(tag_name: String, tag_color: Color) -> void:
	var new_style: StyleBox = get_theme_stylebox(STYLEBOX_KEY).duplicate()
	new_style.bg_color = tag_color
	add_theme_stylebox_override(STYLEBOX_KEY, new_style)
	
	text_label.text = tag_name
	name = tag_name
