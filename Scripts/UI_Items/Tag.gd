class_name Tag
extends MenuButton

const DELETE_TAG = 1

var tag_name: String

@onready var delete_task_dialog: ConfirmationDialog = $DeleteTaskConfirmDialog


func _ready() -> void:
	self.get_popup().id_pressed.connect(_delete_tag)
	delete_task_dialog.visible = false


func set_tag(new_tag_name: String, tag_color: Color) -> void:
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
	
	if tag_color.get_luminance() > 0.6:
		add_theme_color_override("font_color", Color.BLACK)
	else:
		add_theme_color_override("font_color", Color.WHITE)
	
	tag_name = new_tag_name
	text = new_tag_name.to_upper()
	name = new_tag_name.to_upper()


func _delete_tag(id_pressed: int) -> void:
	if id_pressed != DELETE_TAG:
		return

	delete_task_dialog.visible = true

func _on_delete_task_confirm_dialog_confirmed() -> void:
	Database.delete_tag_by_name(tag_name)
	SignalBus.tag_deleted.emit()
