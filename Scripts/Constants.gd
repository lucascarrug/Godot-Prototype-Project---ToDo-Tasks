class_name Constants 
extends Resource

## Database name
const TABLE_NAME: String = "Tasks"


## Database col names.
const ID: String = "id"
const NAME: String = "name"
const DESCRIPTION: String = "description"
const START_DATE: String = "start_date"
const END_DATE: String = "end_date"
const TAGS: String = "tags"
const DONE: String = "done"


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
const SORT_BY_ENDDATE = 1
