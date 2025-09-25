class_name TaskWidgetContainer
extends ScrollContainer

@onready var vbox: VBoxContainer = $VBoxContainer

var TASK_WIDGET_SCENE: PackedScene = preload("res://Scenes/TaskWidget.tscn")

var task_widget_counter: int


func set_container(database: SQLite) -> void:
	var table = database.select_rows(Constants.TABLE_NAME, "", ["*"])
	task_widget_counter = 0
	
	for child in vbox.get_children():
		vbox.remove_child(child)

	for row in table:
		var task: TaskWidget = TASK_WIDGET_SCENE.instantiate()
		task.set_data(row)
		task.name = "TaskWidget" + str(task_widget_counter)
		vbox.add_child(task)
		task_widget_counter += 1
