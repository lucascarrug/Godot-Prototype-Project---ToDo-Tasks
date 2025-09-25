class_name TaskWidget 
extends MarginContainer

@onready var more_info_b: Button = $TaskContainer/HBoxContainer/MoreInfoButton
@onready var name_l: Label = $TaskContainer/HBoxContainer/TaskNameLabel
@onready var start_date_l: RichTextLabel = $TaskContainer/HBoxContainer/DateGrid/StartDateLabel
@onready var end_date_l: RichTextLabel = $TaskContainer/HBoxContainer/DateGrid/EndDateLabel
@onready var description_l: RichTextLabel = $TaskContainer/DescriptionLabel
@onready var tag_container: VBoxContainer = $TaskContainer/TagContainer
@onready var select_tag_container: OptionButton = $TaskContainer/TagContainer/HBoxContainer/SelectTagButton

const TAG_SCENE = preload("res://Scenes/Tag.tscn")
const POPUP_SCENE = preload("res://Scenes/TagPopup.tscn")

var is_more_info_displayed: bool
var is_popup_displayed: bool
var data: Dictionary


func _ready() -> void:
	hide_info()
	
	is_popup_displayed = false
	
	if data:
		print("data id: ", data[Constants.ID])
		name_l.text = data[Constants.NAME]
		if data[Constants.DESCRIPTION]: description_l.text = data[Constants.DESCRIPTION]
		start_date_l.text = "[i][color=#111111]desde [/color][/i] " + data[Constants.START_DATE]
		
		if data[Constants.END_DATE] != null:
			end_date_l.text = "[i][color=#111111]hasta [/color][/i] " + data[Constants.END_DATE]


func _on_add_tag_button_pressed() -> void:
	var tag_popup: TagPopup = get_tree().root.find_child("TagPopup", true, false)
	
	if tag_popup:
		tag_popup.visible = true
		tag_popup.set_last_emitter(self)
	else:
		var new_tag_popup: TagPopup = POPUP_SCENE.instantiate()
		new_tag_popup.new_tag_added_to_sql.connect(_on_tag_popup_accept)
		get_tree().root.add_child(new_tag_popup)
		new_tag_popup.set_last_emitter(self)
	

func _on_tag_popup_accept(last_emitter: TaskWidget, tag_name: String, tag_color: Color) -> void:
	# Flag name.
	if not tag_name:
		print("You must add a name.")
		return
	
	# Insert in SQL.
	var query = 'INSERT OR IGNORE INTO Tags (name, color) VALUES (?, ?)'
	Database.database.query_with_bindings(query, [tag_name.to_upper(), tag_color.to_html(false)])
	_add_tag(last_emitter, tag_name, tag_color)
	
	# Link with Task.
	var success = Database.database.query_with_bindings('SELECT id FROM Tags WHERE name = ?',[tag_name.to_upper()])
	if success and Database.database.query_result.size() > 0:
		var tag_id: int = Database.database.query_result[0]["id"]
		print("El id del tag es: ", tag_id)
	else:
		print("No se encontró el tag con name: ", tag_name)

func _on_more_info_button_pressed() -> void:
	_toggle_info_display()


func _on_select_tag_button_item_selected(index: int) -> void:
	var tag_text: String = select_tag_container.get_item_text(index)
	_add_tag(self, tag_text, Color.RED)
	

func _toggle_info_display() -> void:
	if is_more_info_displayed:
		hide_info()
	else:
		show_info()


func _add_tag(task_widget_to_add: TaskWidget, tag_text: String, tag_color: Color) -> void:
	var new_tag: Tag = TAG_SCENE.instantiate()
	task_widget_to_add.tag_container.add_child(new_tag)
	new_tag.set_tag(tag_text, tag_color)
	print("Tag added to task with id: ", data[Constants.ID])


func show_info() -> void:
	description_l.visible = true
	start_date_l.visible = true
	tag_container.visible = true
	
	is_more_info_displayed = true
	print("Show more.")


func hide_info() -> void:
	description_l.visible = false
	start_date_l.visible = false
	tag_container.visible = false
	
	is_more_info_displayed = false
	print("Show less.")


func set_data(task: Dictionary) -> void:
	data = task
