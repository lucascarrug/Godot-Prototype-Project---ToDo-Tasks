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


## Extras
const DEFAULT_DIR: String = "Default"
const DATABASE_PATH: String = "res://Data/Tasks.db"

## Preload scenes
const TAG_SCENE: PackedScene = preload("res://Scenes/UI_Items/Tag.tscn")
const POPUP_SCENE: PackedScene = preload("res://Scenes/UI_Items/TagPopup.tscn")
const TASK_WIDGET_SCENE: PackedScene = preload("res://Scenes/UI_Items/TaskWidget.tscn")
