class_name TaskWidget 
extends MarginContainer

@onready var more_info_b: Button = $VBoxContainer/HBoxContainer/MoreInfoButton
@onready var name_l: Label = $VBoxContainer/HBoxContainer/TaskNameLabel
@onready var start_date_l: RichTextLabel = $VBoxContainer/HBoxContainer/DateGrid/StartDateLabel
@onready var end_date_l: RichTextLabel = $VBoxContainer/HBoxContainer/DateGrid/EndDateLabel
@onready var description_l: RichTextLabel = $VBoxContainer/DescriptionLabel
@onready var tag_continer: VBoxContainer = $VBoxContainer/TagContiner

var is_more_info_displayed: bool
var data: Dictionary

func _ready() -> void:
	hide_info()
	
	if data:
		print("data id: ", data[Constants.ID])
		name_l.text = data[Constants.NAME]
		if data[Constants.DESCRIPTION]: description_l.text = data[Constants.DESCRIPTION]
		start_date_l.text = "[i][color=#111111]desde [/color][/i] " + data[Constants.START_DATE]
		
		if data[Constants.END_DATE] != null:
			end_date_l.text = "[i][color=#111111]hasta [/color][/i] " + data[Constants.END_DATE]


func _fix_container_size() -> void:
	self.force_update_transform()


func _on_more_info_button_pressed() -> void:
	_toggle_info_display()


func _toggle_info_display() -> void:
	if is_more_info_displayed:
		hide_info()
	else:
		show_info()

func show_info() -> void:
	description_l.visible = true
	start_date_l.visible = true
	tag_continer.visible = true
	
	is_more_info_displayed = true
	print("Show more.")

func hide_info() -> void:
	description_l.visible = false
	start_date_l.visible = false
	tag_continer.visible = false
	
	is_more_info_displayed = false
	print("Show less.")

func set_data(task: Dictionary) -> void:
	data = task
