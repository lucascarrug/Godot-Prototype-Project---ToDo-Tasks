class_name TagPopup
extends Popup

signal new_tag_added_to_sql(last_emmiter, tag_name, tag_color)

var last_emmiter: TaskWidget

@onready var tag_name_text: TextEdit = $MarginContainer/VBoxContainer/TagNameTextEdit
@onready var tag_color_picker: ColorPickerButton = $MarginContainer/VBoxContainer/TagColorPicker


func _on_accept_button_pressed() -> void:
	emit_signal("new_tag_added_to_sql",
		last_emmiter,
		tag_name_text.text, 
		tag_color_picker.color)


func set_last_emitter(emitter: TaskWidget) -> void:
	last_emmiter = emitter
