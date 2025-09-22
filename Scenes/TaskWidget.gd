class_name TaskWidget 
extends MarginContainer

@onready var more_info_b: Button = $VBoxContainer/HBoxContainer/MoreInfoButton
@onready var name_l: Label = $VBoxContainer/HBoxContainer/TaskNameLabel
@onready var start_date_l: RichTextLabel = $VBoxContainer/HBoxContainer/DateGrid/StartDateLabel
@onready var end_date_l: RichTextLabel = $VBoxContainer/HBoxContainer/DateGrid/EndDateLabel
@onready var description_l: RichTextLabel = $VBoxContainer/DescriptionLabel

var C = Constants.new()

var is_more_info_displayed: bool = false

func _ready() -> void:
	description_l.visible = false
	start_date_l.visible = false

func _fix_container_size() -> void:
	self.force_update_transform()

func _on_more_info_button_pressed() -> void:
	_toggle_info_display()

func _toggle_info_display() -> void:
	if is_more_info_displayed:
		description_l.visible = false
		start_date_l.visible = false
		is_more_info_displayed = false
		print("Show less.")
	else:
		description_l.visible = true
		start_date_l.visible = true
		is_more_info_displayed = true
		print("Show more.")


func set_data(task: Dictionary) -> void:
	name_l.text = task[C.NAME]
	description_l.text = task[C.DESCRIPTION]
	start_date_l.text = "[i][color=#111111]desde [/color][/i] " + task[C.START_DATE]
	
	if task[C.END_DATE] != null:
		end_date_l.text = "[i][color=#111111]hasta [/color][/i] " + task[C.END_DATE]
