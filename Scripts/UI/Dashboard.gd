extends Control

@onready var task_container: TaskWidgetContainer = $HBoxContainer/MyTasksMenu/VBoxContainer/TaskWidgetContainer
@onready var sort_button: MenuButton = $HBoxContainer/MyTasksMenu/VBoxContainer/HBoxContainer/SortButton
@onready var filter_button: OptionButton = $HBoxContainer/MyTasksMenu/VBoxContainer/HBoxContainer/FilterButton

func _ready() -> void:
	SignalBus.tag_deleted.connect(_populate_filter_tag_button)
	
	task_container.set_container()
	sort_button.get_popup().id_pressed.connect(_on_sort_button_item_selected)
	_populate_filter_tag_button()
	


func _on_sort_button_item_selected(id) -> void:
	task_container.sort_tasks(id)


func _populate_filter_tag_button() -> void:
	filter_button.clear()
	filter_button.add_item("")
	for tag in Database.get_all_tags():
		filter_button.add_item(tag[Constants.TAG_NAME])


func _on_filter_button_item_selected(index: int) -> void:
	var tag_name: String = filter_button.get_item_text(index)
	task_container.filter_by_tag(tag_name)


func _on_more_info_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		task_container._show_info_from_all_not_done_tasks()
	else:
		task_container._hide_info_from_all_not_done_tasks()
