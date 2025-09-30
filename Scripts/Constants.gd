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
const TAG_SCENE = preload("res://Scenes/Tag.tscn")
const POPUP_SCENE = preload("res://Scenes/TagPopup.tscn")
