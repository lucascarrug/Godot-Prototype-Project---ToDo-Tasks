extends Control

@onready var task_container = $Menu/VBoxContainer/TaskWidgetContainer

func _ready() -> void:
	task_container.set_container()
