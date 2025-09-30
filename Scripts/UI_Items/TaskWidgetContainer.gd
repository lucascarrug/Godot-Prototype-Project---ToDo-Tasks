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
		vbox.add_child(task)
		task_widget_counter += 1
