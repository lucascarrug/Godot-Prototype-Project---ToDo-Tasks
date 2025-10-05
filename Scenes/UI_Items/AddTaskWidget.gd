extends MarginContainer

signal new_task_added

@onready var name_edit = $HBoxContainer/NameEdit
@onready var date_edit = $HBoxContainer/DateEdit


func _on_add_button_pressed() -> void:
	if name_edit.text == "":
		return
	
	Database.insert_task(name_edit.text, "", date_edit.text)
	
	name_edit.text = ""
	date_edit.text = ""
	
	new_task_added.emit()
