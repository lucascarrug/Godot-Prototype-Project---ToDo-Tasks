class_name Constants 
extends Resource

## Database name
const TABLE_NAME: String = "Tasks"

## Tasks cols.
const TASK_ID: String = "id"
const TASK_NAME: String = "name"
const TASK_DESCRIPTION: String = "description"
const TASK_START_DATE: String = "start_date"
const TASK_END_DATE: String = "end_date"
const TASK_TAGS: String = "tags"
const TASK_DONE: String = "done"

## Tags cols.
const TAG_ID: String = "id"
const TAG_NAME: String = "name"
const TAG_COLOR: String = "color"

## Tasks_Tags cols.
const TASKTAG_TASK_ID: String = "task_id"
const TASKTAG_TAG_ID: String = "tag_id"

## IDK.
const TAGPOPUP_NAME: String = "TagPopup"

## Extras.
const DEFAULT_DIR: String = "Default"
const DATABASE_PATH: String = "res://Data/Tasks.db"

## Preload scenes.
const TAG_SCENE: PackedScene = preload("res://Scenes/UI_Items/Tag.tscn")
const POPUP_SCENE: PackedScene = preload("res://Scenes/UI_Items/TagPopup.tscn")
const TASK_WIDGET_SCENE: PackedScene = preload("res://Scenes/UI_Items/TaskWidget.tscn")

## Resources.
const TASK_WIDGET_NOT_DONE_STYLEBOX: StyleBoxFlat = preload("res://Assets/StyleBoxFlat/TaskWidgetNotDone.tres")
const TASK_WIDGET_DONE_STYLEBOX: StyleBoxFlat = preload("res://Assets/StyleBoxFlat/TaskWidgetDone.tres")

## Sort methods.
const SORT_BY_ALPHABET = 0
const SORT_BY_STARTDATE = 1
const SORT_BY_ENDDATE = 2
