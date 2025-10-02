class_name TaskWidgetContainer
extends ScrollContainer

var task_widget_counter: int

@onready var vbox: VBoxContainer = $VBoxContainer


func set_container() -> void:
	var table = Database.database.select_rows(Constants.TABLE_NAME, "", ["*"])
	task_widget_counter = 0
	
	for child in vbox.get_children():
		vbox.remove_child(child)

	for row in table:
		var task: TaskWidget = Constants.TASK_WIDGET_SCENE.instantiate()
		task.set_data(row)
		task.name = "TaskWidget" + str(task_widget_counter)
		task.new_tag_created.connect(_update_tasks_select_tag_button)
		vbox.add_child(task)
		task_widget_counter += 1
	
	_update_tasks_stylebox()

func _update_tasks_select_tag_button() -> void:
	for task in vbox.get_children():
		if not is_instance_of(task, TaskWidget):
			return
		task._populate_select_tag_button()


func _update_tasks_stylebox() -> void:
	for task in vbox.get_children():
		if not is_instance_of(task, TaskWidget):
			return
		
		var task_done = Database.is_task_done(task._get_task_id())
		if task_done:
			task._set_style_task_done()
			task.done_button.button_pressed = true
		else:
			task._set_style_task_not_done()
			task.done_button.button_pressed = false
