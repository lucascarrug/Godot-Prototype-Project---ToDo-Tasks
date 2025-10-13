extends Control

@onready var task_container := $TaskWidgetContainer

func _insert_task():
	var table = {
		Constants.TASK_START_DATE: Utils.get_current_day(),
		Constants.TASK_DONE: false
	}
	
	# Insert name.
	if $NameText.text != "":
		table[Constants.TASK_NAME] = $NameText.text
	else:
		print("Empty name.")
		return
	
	# Insert description.
	if $DescriptionText.text != "":
		table[Constants.TASK_DESCRIPTION] = $DescriptionText.text
	else:
		print("Empty description.")
	
	# Insert end date.
	if Utils.is_valid_date_format($EndDateText.text):
		table[Constants.TASK_END_DATE] = $EndDateText.text
	
	# Insert in table.
	Database.database.insert_row(Constants.TASK_TABLE, table)
	print("Task ", $NameText.text, " inserted.")
	

func _on_insert_data_button_pressed() -> void:
	_insert_task()


func _on_update_widget_button_pressed() -> void:
	task_container.set_container()
	

func _on_mostrar_data_button_pressed() -> void:
	var table: Array = Database.database.select_rows(Constants.TASK_TABLE, "", ["*"])
	
	if table.size() == 0:
		print("No tasks added.")
		return
		
	for row in table:
		print("task: ", row[Constants.TASK_NAME], " -> ", row[Constants.TASK_DESCRIPTION], " :: ", row[Constants.TASK_END_DATE], " :: done ", row[Constants.TASK_DONE]) 


func _on_next_task_button_pressed() -> void:
	pass
