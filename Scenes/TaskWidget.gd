class_name TaskWidget 
extends Control

@onready var more_info_b: Button = $MarginContainer/VBoxContainer/HBoxContainer/MoreInfoButton
@onready var name_l: Label = $MarginContainer/VBoxContainer/HBoxContainer/TaskNameLabel
@onready var start_date_l: Label = $MarginContainer/VBoxContainer/HBoxContainer/DateGrid/StartDateLabel
@onready var end_date_l: Label = $MarginContainer/VBoxContainer/HBoxContainer/DateGrid/EndDateLabel
@onready var description_l: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var container: MarginContainer = $MarginContainer

var is_more_info_displayed : bool = false

func _ready() -> void:
	description_l.visible = false
	start_date_l.visible = false

func _fix_container_size() -> void:
	container.force_update_transform()

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
