class_name Constants extends Resource

## Database name
const TABLE_NAME: String = "Tasks"


## Database col names.
const ID: String = "id"
const NAME: String = "name"
const DESCRIPTION: String = "description"
const START_DATE: String = "start_date"
const END_DATE: String = "end_date"
const TAGS: String = "tags"

## Database table.
var TABLE = {
		ID: {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		NAME: {"data_type": "text"},
		DESCRIPTION: {"data_type": "text"},
		START_DATE: {"data_type": "date"},
		END_DATE: {"data_type": "date"},
		TAGS: {"data_type": "text"}
	}


## Extras
const DEFAULT_DIR: String = "Default"
const DATABASE_PATH: String = "res://Data/Tasks.db"
