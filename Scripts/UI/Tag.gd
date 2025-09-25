class_name Tag
extends PanelContainer

@export var color: Color
@export var tag: String

@onready var text_l: Label = $Text


func _ready() -> void:
	pass


func set_tag(_tag: String = "None", _color: Color = Color.LIGHT_BLUE) -> void:
	var current_style = get_theme_stylebox("panel")
	current_style.bg_color = _color
	text_l.text = _tag
