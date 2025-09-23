class_name DatabaseManager
extends Node

var database: SQLite

func _ready():
	database = SQLite.new()
	database.path = Constants.DATABASE_PATH
	database.open_db()
	_create_tables()

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
		name TEXT NOT NULL
	)
	")
	
	database.query("
	CREATE TABLE IF NOT EXISTS Tasks_Tags (
		task_id INTEGER,
		tag_id INTEGER,
		PRIMARY KEY (task_id, tag_id)
	)
	")
