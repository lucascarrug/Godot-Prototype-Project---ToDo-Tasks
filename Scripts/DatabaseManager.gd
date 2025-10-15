class_name DatabaseManager
extends Node

var database: SQLite


func _ready():
	database = SQLite.new()
	database.path = Constants.DATABASE_PATH
	database.open_db()
	_create_tables()

##### CREATE FUNCTIONS

func _create_tables() -> void:
	database.query("
	CREATE TABLE IF NOT EXISTS Tasks (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT NOT NULL,
		description TEXT,
		start_date DATE NOT NULL,
		end_date DATE,
		done BOOLEAN
	)
	")
	
	database.query("
	CREATE TABLE IF NOT EXISTS Tags (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT NOT NULL UNIQUE,
		color JSON NOT NULL
	)
	")
	
	database.query("
	CREATE TABLE IF NOT EXISTS Tasks_Tags (
		task_id INTEGER NOT NULL,
		tag_id INTEGER NOT NULL,
		PRIMARY KEY (task_id, tag_id)
	);
	")

##### SELECT FUNCTIONS

func get_task_name_by_id(task_id: int) -> String:
	var query: String = 'SELECT %s FROM %s WHERE %s = ?' % [Constants.TASK_NAME, Constants.TASK_TABLE, Constants.TASK_ID]
	database.query_with_bindings(query, [task_id])
	return database.query_result.front()[Constants.TASK_NAME]


func get_task_data_by_id(task_id: int) -> Dictionary:
	database.select_rows(Constants.TASK_TABLE, "%s = %d" % [Constants.TASK_ID, task_id], ["*"])
	return database.query_result.front()


func get_tag_id_by_name(tag_name: String) -> int:
	var query: String = 'SELECT %s FROM %s WHERE %s = ?' % [Constants.TAG_ID, Constants.TAG_TABLE, Constants.TAG_NAME]
	database.query_with_bindings(query, [tag_name.to_upper()])
	return database.query_result.front()[Constants.TAG_ID]

	
func get_tag_color_by_name(tag_name: String) -> Color:
	var query: String = 'SELECT %s FROM %s WHERE %s = ?' % [Constants.TAG_COLOR, Constants.TAG_TABLE, Constants.TAG_NAME]
	database.query_with_bindings(query, [tag_name])
	return database.query_result.front()[Constants.TAG_COLOR]


func get_tags_by_task(task_id: int) -> Array:
	var query: String = 'SELECT %s FROM %s WHERE %s = ?' % [Constants.TASKTAG_TAG_ID, Constants.TASKTAG_TABLE, Constants.TASKTAG_TASK_ID]
	database.query_with_bindings(query, [task_id])
	return database.query_result


func get_tag_name_by_id(tag_id: int) -> String:
	var query: String = 'SELECT %s FROM %s WHERE %s = ?' % [Constants.TAG_NAME, Constants.TAG_TABLE, Constants.TAG_ID]
	database.query_with_bindings(query, [tag_id])
	return database.query_result.front()[Constants.TAG_NAME]


func get_tag_color_by_id(tag_id: int) -> Color:
	var query: String = 'SELECT %s FROM %s WHERE %s = ?' % [Constants.TAG_COLOR, Constants.TAG_TABLE, Constants.TAG_ID]
	database.query_with_bindings(query, [tag_id])
	return database.query_result.front()[Constants.TAG_COLOR]


func get_all_tags() -> Array:
	var query: String = 'SELECT %s FROM %s' % [Constants.TAG_NAME, Constants.TAG_TABLE]
	database.query(query)
	return database.query_result


func is_task_done(task_id: int) -> bool:
	var query: String = 'SELECT %s FROM %s WHERE %s = ?' % [Constants.TASK_DONE, Constants.TASK_TABLE, Constants.TASK_ID]
	database.query_with_bindings(query, [task_id])
	return database.query_result.front()[Constants.TASK_DONE]

##### INSERT FUNCTIONS

func insert_tag(tag_name: String, tag_color: Color) -> void:
	var query: String = 'INSERT OR IGNORE INTO %s (%s, %s) VALUES (?, ?)' % [Constants.TAG_TABLE, Constants.TAG_NAME, Constants.TAG_COLOR]
	database.query_with_bindings(query, [tag_name.to_upper(), tag_color.to_html(false)])


func insert_task_tag(task_id: int, tag_id: int) -> void:
	var query: String = 'INSERT OR IGNORE INTO %s (%s, %s) VALUES (?, ?)' % [Constants.TASKTAG_TABLE, Constants.TASKTAG_TASK_ID, Constants.TASKTAG_TAG_ID]
	database.query_with_bindings(query, [task_id, tag_id])


func insert_task(task_name: String, task_description: String = "", task_end_date: String = "") -> void:
	# Default settings.
	var table: Dictionary = {
		Constants.TASK_NAME: null,
		Constants.TASK_DESCRIPTION: null,
		Constants.TASK_START_DATE: Utils.get_current_day(),
		Constants.TASK_END_DATE: null,
		Constants.TASK_DONE: false
	}
	
	# Insert name.
	if task_name != "":
		table[Constants.TASK_NAME] = task_name
	else:
		print("Empty name.")
		return
	
	# Insert description.
	if task_description != "":
		table[Constants.TASK_DESCRIPTION] = task_description
	else:
		print("Empty description.")
	
	# Insert end date.
	if Utils.is_valid_date_format(task_end_date):
		table[Constants.TASK_END_DATE] = task_end_date
	
	# Insert in table.
	Database.database.insert_row(Constants.TASK_TABLE, table)
	print("Task ", task_name, " inserted.")


## DELETE FUNCTIONS

func delete_task_tag(task_id: int, tag_id: int) -> void:
	var query: String = 'DELETE FROM %s WHERE %s = ? AND %s = ?' % [Constants.TASKTAG_TABLE, Constants.TASKTAG_TASK_ID, Constants.TASKTAG_TAG_ID]
	database.query_with_bindings(query, [task_id, tag_id])


func delete_task(task_id: int) -> void:
	var query: String = 'DELETE FROM %s WHERE %s = ?' % [Constants.TASK_TABLE, Constants.TASK_ID]
	database.query_with_bindings(query, [task_id])
	
	query = 'DELETE FROM %s WHERE %s = ?' % [Constants.TASKTAG_TABLE, Constants.TASKTAG_TASK_ID]
	database.query_with_bindings(query, [task_id])


func delete_tag_by_name(tag_name: String) -> void:
	var tag_id = get_tag_id_by_name(tag_name)
	
	var query: String = 'DELETE FROM %s WHERE %s = ?' % [Constants.TAG_TABLE, Constants.TAG_ID]
	database.query_with_bindings(query, [tag_id])
	
	query = 'DELETE FROM %s WHERE %s = ?' % [Constants.TASKTAG_TABLE, Constants.TASKTAG_TAG_ID]
	database.query_with_bindings(query, [tag_id])

## UPDATE FUNCTIONS

func set_task_done(task_id: int) -> void:
	var query: String = 'UPDATE %s SET %s = TRUE WHERE %s = ?' % [Constants.TASK_TABLE, Constants.TASK_DONE, Constants.TASK_ID]
	database.query_with_bindings(query, [task_id])


func set_task_not_done(task_id: int) -> void:
	var query: String = 'UPDATE %s SET %s = FALSE WHERE %s = ?' % [Constants.TASK_TABLE, Constants.TASK_DONE, Constants.TASK_ID]
	database.query_with_bindings(query, [task_id])
	
	
func update_task(task_id: int, task_name: String, task_description: String, task_end_date: String) -> void:
	# Default col update if entry is empty.
	var table_update: Dictionary = {
		Constants.TASK_NAME: "Tarea " + str(task_id),
		Constants.TASK_DESCRIPTION: null,
	}
	
	if task_name != "":
		table_update[Constants.TASK_NAME] = task_name
	
	if task_description != "":
		table_update[Constants.TASK_DESCRIPTION] = task_description
	
	if Utils.is_valid_date_format(task_end_date):
		table_update[Constants.TASK_END_DATE] = task_end_date
	elif task_end_date == "":
		table_update[Constants.TASK_END_DATE] = null
	
	
	database.update_rows(Constants.TASK_TABLE, "%s = %d" % [Constants.TASK_ID, task_id], table_update)
