class_name TaskWidgetContainer
extends VBoxContainer

var C = Constants.new()

func _ready() -> void:
	pass
	
func set_container(database: SQLite) -> void:
	var table = database.select_rows(C.TABLE_NAME, "", ["*"])
	var task_scene: PackedScene = preload("res://Scenes/TaskWidget.tscn")
	
	for child in self.get_children():
		self.remove_child(child)

	for row in table:
		var task: TaskWidget = task_scene.instantiate()
		task.set_data(row)
		add_child(task)
