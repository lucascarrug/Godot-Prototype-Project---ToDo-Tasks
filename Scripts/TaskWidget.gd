class_name TaskWidget 
extends MarginContainer

@onready var more_info_b: Button = $TaskContainer/HBoxContainer/MoreInfoButton
@onready var name_l: Label = $TaskContainer/HBoxContainer/TaskNameLabel
@onready var start_date_l: RichTextLabel = $TaskContainer/HBoxContainer/DateGrid/StartDateLabel
@onready var end_date_l: RichTextLabel = $TaskContainer/HBoxContainer/DateGrid/EndDateLabel
@onready var description_l: RichTextLabel = $TaskContainer/DescriptionLabel
@onready var tag_container: VBoxContainer = $TaskContainer/TagContainer
@onready var select_tag_container: OptionButton = $TaskContainer/TagContainer/HBoxContainer/SelectTagButton


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
	if not is_popup_displayed:
		var popup_scene = preload("res://Scenes/TagPopup.tscn")
		var tag_popup = popup_scene.instantiate()
		tag_popup.visible = true
		tag_container.add_child(tag_popup)


func _on_more_info_button_pressed() -> void:
	_toggle_info_display()


func _on_select_tag_button_item_selected(index: int) -> void:
	var tag_text: String = select_tag_container.get_item_text(index)
	var tag_scene = preload("res://Scenes/Tag.tscn")
	var new_tag: Tag = tag_scene.instantiate()
	tag_container.add_child(new_tag)
	new_tag.set_tag(Color.RED, tag_text)
	

func _toggle_info_display() -> void:
	if is_more_info_displayed:
		hide_info()
	else:
		show_info()


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
