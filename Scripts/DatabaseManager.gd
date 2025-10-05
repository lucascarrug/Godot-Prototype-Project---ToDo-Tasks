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

func get_tag_id_by_name(tag_name: String) -> int:
	database.query_with_bindings('SELECT id FROM Tags WHERE name = ?',[tag_name.to_upper()])
	return database.query_result.front()["id"]

	
func get_tag_color_by_name(tag_name: String) -> Color:
	database.query_with_bindings('SELECT color FROM Tags WHERE name = ?', [tag_name])
	return database.query_result.front()["color"]


func get_tags_by_task(task_id: int) -> Array:
	database.query_with_bindings('SELECT tag_id FROM Tasks_Tags WHERE task_id = ?', [task_id])
	return database.query_result


func get_tag_name_by_id(tag_id: int) -> String:
	database.query_with_bindings('SELECT name FROM Tags WHERE id = ?', [tag_id])
	return database.query_result.front()["name"]


func get_tag_color_by_id(tag_id: int) -> Color:
	database.query_with_bindings('SELECT color FROM Tags WHERE id = ?', [tag_id])
	return database.query_result.front()["color"]


func get_all_tags() -> Array:
	database.query('SELECT name FROM Tags')
	return database.query_result


func is_task_done(task_id: int) -> bool:
	database.query_with_bindings('SELECT done FROM Tasks WHERE id = ?', [task_id])
	return database.query_result.front()["done"]

##### INSERT FUNCTIONS

func insert_tag(tag_name: String, tag_color: Color) -> void:
	var query = 'INSERT OR IGNORE INTO Tags (name, color) VALUES (?, ?)'
	database.query_with_bindings(query, [tag_name.to_upper(), tag_color.to_html(false)])


func insert_task_tag(task_id: int, tag_id: int) -> void:
	database.query_with_bindings('INSERT OR IGNORE INTO Tasks_Tags (task_id, tag_id) VALUES (?, ?);', [task_id, tag_id])


func set_task_done(task_id: int) -> void:
	database.query_with_bindings('UPDATE Tasks SET done = TRUE WHERE id = ?', [task_id])


func set_task_not_done(task_id: int) -> void:
	database.query_with_bindings('UPDATE Tasks SET done = FALSE WHERE id = ?', [task_id])


func insert_task(task_name: String, task_description: String = "", task_end_date: String = "") -> void:
	var table = {
		Constants.START_DATE: Utils.get_current_day(),
		Constants.DONE: false
	}
	
	# Insert name.
	if task_name != "":
		table[Constants.NAME] = task_name
	else:
		print("Empty name.")
		return
	
	# Insert description.
	if task_description != "":
		table[Constants.DESCRIPTION] = task_description
	else:
		print("Empty description.")
	
	# Insert end date.
	if Utils.is_valid_date_format(task_end_date):
		table[Constants.END_DATE] = task_end_date
	
	# Insert in table.
	Database.database.insert_row(Constants.TABLE_NAME, table)
	print("Task ", task_name, " inserted.")


## DELETE FUNCTIONS

func delete_task_tag(task_id: int, tag_id: int) -> void:
	var query = 'DELETE FROM Tasks_Tags WHERE task_id = ? AND tag_id = ?'
	database.query_with_bindings(query, [task_id, tag_id])
