class_name TagPopup
extends Popup

signal new_tag_added_to_sql(tag_name, tag_color)

@onready var tag_name_text: TextEdit = $MarginContainer/VBoxContainer/TagNameTextEdit
@onready var tag_color_picker: ColorPickerButton = $MarginContainer/VBoxContainer/TagColorPicker

func _on_accept_button_pressed() -> void:
	emit_signal("new_tag_added_to_sql", tag_name_text.text, tag_color_picker.color)
