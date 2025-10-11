class_name TaskWidget 
extends MarginContainer

signal new_tag_created
signal tag_done_status_changed
signal can_drop_data_emited

const DELETE_TASK = 0

var is_more_info_displayed: bool
var is_popup_displayed: bool
var data: Dictionary

@onready var background: Panel = $Background
@onready var more_info_b: Button = $TaskContainer/HBoxContainer/MoreInfoButton
@onready var name_l: Label = $TaskContainer/HBoxContainer/TaskNameLabel
@onready var start_date_l: RichTextLabel = $TaskContainer/HBoxContainer/DateGrid/StartDateLabel
@onready var end_date_l: RichTextLabel = $TaskContainer/HBoxContainer/DateGrid/EndDateLabel
@onready var description_l: RichTextLabel = $TaskContainer/DescriptionLabel
@onready var tag_container: VBoxContainer = $TaskContainer/TagContainer
@onready var select_tag_button: OptionButton = $TaskContainer/TagContainer/HBoxContainer/SelectTagButton
@onready var done_button: Button = $TaskContainer/HBoxContainer/DoneButton
@onready var delete_button: Button = $TaskContainer/HBoxContainer/DeleteButton
@onready var delete_confirm_dialog: ConfirmationDialog = $DeleteConfirmDialog
@onready var edit_task_popup: EditTaskPopup = $EditTaskPopup

##### OVERRIDE

func _ready() -> void:
	_hide_info()
	is_popup_displayed = false
	delete_button.visible = false
	
	if not data:
		return
	
	name_l.text = data[Constants.NAME]
	if data[Constants.DESCRIPTION]: description_l.text = data[Constants.DESCRIPTION]
	start_date_l.text = data[Constants.START_DATE]
	
	if data[Constants.END_DATE] != null:
		end_date_l.text = data[Constants.END_DATE]

	_load_tags_from_db()
	_populate_select_tag_button()
	edit_task_popup.set_edit_popup(data[Constants.ID])
	edit_task_popup.data_updated.connect(_on_data_updated)
	
##### SIGNALS

func _on_add_tag_button_pressed() -> void:
	var tag_popup: TagPopup = get_tree().root.find_child(Constants.TAGPOPUP_NAME, true, false)
	
	if tag_popup:
		tag_popup.visible = true
		tag_popup.set_last_emitter(self)
	else:
		var new_tag_popup: TagPopup = Constants.POPUP_SCENE.instantiate()
		new_tag_popup.name = Constants.TAGPOPUP_NAME
		new_tag_popup.new_tag_added_to_sql.connect(_on_tag_popup_accept)
		new_tag_popup.set_last_emitter(self)
		get_tree().root.add_child(new_tag_popup)
	

func _on_tag_popup_accept(last_emitter: TaskWidget, tag_name: String, tag_color: Color) -> void:
	if not tag_name or _tag_exists(tag_name):
		return
	
	Database.insert_tag(tag_name, tag_color)
	_add_tag_in_tag_container(last_emitter, tag_name, tag_color)
	new_tag_created.emit()


func _on_more_info_button_pressed() -> void:
	if is_more_info_displayed:
		_hide_info()
	else:
		_show_info()


func _on_select_tag_button_item_selected(index: int) -> void:
	var tag_name: String = select_tag_button.get_item_text(index)
	if _tag_exists(tag_name):
		return

	var tag_color = Database.get_tag_color_by_name(tag_name)
	_add_tag_in_tag_container(self, tag_name, tag_color)


@warning_ignore("unused_parameter")
func _on_done_button_toggled(toggled_on: bool) -> void:
	if Database.is_task_done(_get_task_id()):
		Database.set_task_not_done(_get_task_id())
		_set_style_task_not_done()
	else:
		Database.set_task_done(_get_task_id())
		_set_style_task_done()
		
	tag_done_status_changed.emit()


func _on_delete_button_pressed() -> void:
	delete_confirm_dialog.visible = true


func _on_delete_confirm_dialog_confirmed() -> void:
	_delete_task()


func _on_edit_button_pressed() -> void:
	edit_task_popup.visible = true
	

func _on_data_updated() -> void:
	data = Database.get_task_data_by_id(data[Constants.ID])
	
	name_l.text = data[Constants.NAME]
	if data[Constants.DESCRIPTION]: description_l.text = data[Constants.DESCRIPTION]
	start_date_l.text = data[Constants.START_DATE]
	
	if data[Constants.END_DATE] != null:
		end_date_l.text = data[Constants.END_DATE]

##### PUBLIC

func set_data(new_data: Dictionary) -> void:
	data = new_data


func safe_button_pressed(button_pressed: bool) -> void:
	done_button.set_pressed_no_signal(button_pressed)

##### PRIVATE / HELPERS

func _add_tag_in_tag_container(task_widget_to_add: TaskWidget, tag_name: String, tag_color: Color) -> void:
	var new_tag: Tag = Constants.TAG_SCENE.instantiate()
	new_tag.get_popup().id_pressed.connect(_delete_tag_from_task.bind(new_tag))
	task_widget_to_add.tag_container.add_child(new_tag)
	new_tag.set_tag(tag_name, tag_color)
	
	var task_id: int = task_widget_to_add._get_task_id()
	var tag_id: int = Database.get_tag_id_by_name(tag_name)
	Database.insert_task_tag(task_id, tag_id)


func _load_tags_from_db() -> void:
	var tag_ids = Database.get_tags_by_task(_get_task_id())
	
	for tag in tag_ids:
		var tag_id = tag["tag_id"]
		var tag_name: String = Database.get_tag_name_by_id(tag_id)
		var tag_color: Color = Database.get_tag_color_by_id(tag_id)
		_add_tag_in_tag_container(self, tag_name, tag_color)


func _populate_select_tag_button() -> void:
	select_tag_button.clear()
	for tag in Database.get_all_tags():
		select_tag_button.add_item(tag["name"])


func _tag_exists(new_tag_name: String) -> bool:
	for tag in tag_container.get_children():
		if not is_instance_of(tag, Tag):
			continue
		if tag.name == new_tag_name:
			return true
	
	return false


func _show_info() -> void:
	description_l.visible = true
	start_date_l.visible = true
	tag_container.visible = true
	
	is_more_info_displayed = true


func _hide_info() -> void:
	description_l.visible = false
	start_date_l.visible = false
	tag_container.visible = false
	
	is_more_info_displayed = false
 

func _get_task_id() -> int:
	return data[Constants.ID]
	

func _set_style_task_done() -> void:
	background.add_theme_stylebox_override("panel", Constants.TASK_WIDGET_DONE_STYLEBOX)
	delete_button.visible = true
	

func _set_style_task_not_done() -> void:
	background.add_theme_stylebox_override("panel", Constants.TASK_WIDGET_NOT_DONE_STYLEBOX)
	delete_button.visible = false


@warning_ignore("unused_parameter")
func _get_drag_data(at_position: Vector2) -> Variant:
	can_drop_data_emited.emit()
	return self


func _delete_task() -> void:
	Database.delete_task(data[Constants.ID])
	queue_free()


func _delete_tag_from_task(id_pressed: int, sender: Tag) -> void:
	if id_pressed != DELETE_TASK:
		return
	
	var task_id = data[Constants.ID]
	var tag_id = Database.get_tag_id_by_name(sender.text)
	Database.delete_task_tag(task_id, tag_id)
	
	tag_container.remove_child(sender)
