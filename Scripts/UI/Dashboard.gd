extends Control

@onready var task_container = $Menu/VBoxContainer/TaskWidgetContainer
@onready var sort_button = $Menu/VBoxContainer/HBoxContainer/SortButton


func _ready() -> void:
	task_container.set_container()
	sort_button.get_popup().id_pressed.connect(_on_sort_button_item_selected)


func _on_sort_button_item_selected(id) -> void:
	task_container.sort_tasks(id)
