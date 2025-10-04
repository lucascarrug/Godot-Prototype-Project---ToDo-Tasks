class_name TaskWidgetContainer
extends ScrollContainer

var task_widget_counter: int
var current_slot = 0
var prev_slot = 0

@onready var not_done_task_container: VBoxContainer = $VBoxContainer/NotDoneTasksContainer
@onready var done_task_container: VBoxContainer = $VBoxContainer/DoneTasksContainer


func _on_can_drop_data_emited() -> void:
	_hide_info_from_all_not_done_tasks()


func set_container() -> void:
	var table = Database.database.select_rows(Constants.TABLE_NAME, "", ["*"])
	task_widget_counter = 0
	
	for child in not_done_task_container.get_children():
		not_done_task_container.remove_child(child)

	for row in table:
		var task: TaskWidget = Constants.TASK_WIDGET_SCENE.instantiate()
		task.set_data(row)
		task.name = "TaskWidget" + str(task_widget_counter)
		task.new_tag_created.connect(_update_tasks_select_tag_button)
		task.tag_done_status_changed.connect(_update_containers_by_done_status)
		task.can_drop_data_emited.connect(_on_can_drop_data_emited)
		not_done_task_container.add_child(task)
		task_widget_counter += 1
	
	_update_task_styleboxes()
	_update_containers_by_done_status()


func _update_tasks_select_tag_button() -> void:
	for task in not_done_task_container.get_children():
		if not is_instance_of(task, TaskWidget):
			return
		task._populate_select_tag_button()


func _update_task_styleboxes() -> void:
	for task in not_done_task_container.get_children():
		if not is_instance_of(task, TaskWidget):
			continue
		
		var task_done = Database.is_task_done(task._get_task_id())
		if task_done:
			task._set_style_task_done()
			task.safe_button_pressed(true)
		else:
			task._set_style_task_not_done()
			task.safe_button_pressed(false)


func _update_containers_by_done_status() -> void:
	var all_tasks = not_done_task_container.get_children() + done_task_container.get_children()

	for task in all_tasks.duplicate():
		if not is_instance_of(task, TaskWidget):
			continue

		var task_done = Database.is_task_done(task._get_task_id())

		if task_done:
			if task.get_parent() == done_task_container: 
				continue
			task.get_parent().remove_child(task)
			done_task_container.add_child(task)
		else:
			if task.get_parent() == not_done_task_container: 
				continue
			task.get_parent().remove_child(task)
			not_done_task_container.add_child(task)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not is_instance_of(data, TaskWidget):
		return false
	
	if not data.get_parent() == not_done_task_container:
		return false
	
	current_slot = clamp(int(at_position.y / _get_task_widget_size_y()), 0, not_done_task_container.get_children().size())
	if current_slot != prev_slot:
		print(current_slot)
		not_done_task_container.move_child(data, current_slot)
	
	prev_slot = clamp(int(at_position.y / _get_task_widget_size_y()), 0, not_done_task_container.get_children().size())
	
	return true

@warning_ignore("unused_parameter")
func _drop_data(at_position: Vector2, data: Variant) -> void:
	pass


func _hide_info_from_all_not_done_tasks() -> void:
	var tasks = not_done_task_container.get_children()
	for task in tasks:
		if not is_instance_of(task, TaskWidget):
			continue
			
		if not task.is_more_info_displayed:
			continue
		task._hide_info()
		task.is_more_info_displayed = false


func _get_task_widget_size_y() -> float:
	for child in not_done_task_container.get_children():
		if is_instance_of(child, TaskWidget):
			return child.size.y
	
	return -1000
