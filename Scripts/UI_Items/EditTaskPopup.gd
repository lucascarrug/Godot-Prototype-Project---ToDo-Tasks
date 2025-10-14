class_name EditTaskPopup
extends PopupPanel

signal data_updated

var task_id: int

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var name_edit: LineEdit = $VBoxContainer/HBoxContainer/NameLineEdit
@onready var end_date_edit: LineEdit = $VBoxContainer/HBoxContainer2/EndDateLineEdit
@onready var description_edit: LineEdit = $VBoxContainer/HBoxContainer3/DescriptionLineEdit

func _ready() -> void:
	print("EditTaskPopup._ready")

func _on_modify_button_pressed() -> void:
	var new_name = name_edit.text
	var new_end_date = end_date_edit.text
	var new_description = description_edit.text
	
	Database.update_task(task_id, new_name, new_description, new_end_date)
	update_title()
	visible = false
	data_updated.emit()


func set_edit_popup(_task_id: int) -> void:
	task_id = _task_id
	update_title()


func update_title() -> void:
	title_label.text = "Modificando " + Database.get_task_name_by_id(task_id)


func _on_visibility_changed() -> void:
	var task_data: Dictionary = Database.get_task_data_by_id(task_id)
	
	name_edit.text = task_data[Constants.TASK_NAME]
	
	if task_data[Constants.TASK_END_DATE] != null:
		end_date_edit.text = task_data[Constants.TASK_END_DATE]
	else:
		end_date_edit.text = ""
	
	if task_data[Constants.TASK_DESCRIPTION] != null:
		description_edit.text = task_data[Constants.TASK_DESCRIPTION]
	else:
		description_edit.text = ""
	
