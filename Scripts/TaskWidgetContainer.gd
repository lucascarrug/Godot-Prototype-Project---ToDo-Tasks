class_name TaskWidgetContainer
extends ScrollContainer

@onready var vbox: VBoxContainer = $VBoxContainer

var C = Constants.new()


func _ready() -> void:
	pass


func set_container(database: SQLite) -> void:
	var table = database.select_rows(C.TABLE_NAME, "", ["*"])
	var task_scene: PackedScene = preload("res://Scenes/TaskWidget.tscn")
	
	for child in vbox.get_children():
		vbox.remove_child(child)

	for row in table:
		var task: TaskWidget = task_scene.instantiate()
		task.set_data(row)
		vbox.add_child(task)
