class_name Tag
extends MenuButton

@export var color: Color
@export var tag: String


func set_tag(tag_name: String, tag_color: Color) -> void:
	var normal_style: StyleBox = get_theme_stylebox("normal").duplicate()
	var pressed_style: StyleBox = get_theme_stylebox("pressed").duplicate()
	var hover_style: StyleBox = get_theme_stylebox("hover").duplicate()
	var focus_style: StyleBox = get_theme_stylebox("focus").duplicate()
	
	normal_style.bg_color = tag_color
	pressed_style.bg_color = tag_color.darkened(0.2)
	hover_style.bg_color = tag_color.lightened(0.2)
	focus_style.bg_color = tag_color.lightened(0.2)
	
	add_theme_stylebox_override("normal", normal_style)
	add_theme_stylebox_override("pressed", pressed_style)
	add_theme_stylebox_override("hover", hover_style)
	add_theme_stylebox_override("focus", focus_style)
	
	if tag_color.get_luminance() > 0.8:
		add_theme_color_override("font_color", Color.BLACK)
	else:
		add_theme_color_override("font_color", Color.WHITE)
	
	text = tag_name.to_upper()
	name = tag_name.to_upper()
