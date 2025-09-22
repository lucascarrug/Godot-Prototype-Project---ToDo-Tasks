extends Control

@onready var task_widget := $VBoxContainer/TaskWidget
@onready var task_widget2 := $VBoxContainer/TaskWidget2
@onready var task_container := $TaskWidgetContainer

var C = Constants.new()
var database: SQLite

var i: int = 0

func _ready():
	database = SQLite.new()
	database.path = C.DATABASE_PATH
	database.open_db()
	_create_tables()


func _insert_task():
	var table = {
		C.START_DATE: Utils.get_current_day(),
		C.DONE: false
	}
	
	# Insert name.
	if $NameText.text != "":
		table[C.NAME] = $NameText.text
	else:
		print("Empty name.")
		return
	
	# Insert description.
	if $DescriptionText.text != "":
		table[C.DESCRIPTION] = $DescriptionText.text
	else:
		print("Empty description.")
	
	# Insert end date.
	if Utils.is_valid_date_format($EndDateText.text):
		table[C.END_DATE] = $EndDateText.text
	
	# Insert in table.
	database.insert_row(C.TABLE_NAME, table)
	print("Task ", $NameText.text, " inserted.")
	

func _on_insert_data_button_pressed() -> void:
	_insert_task()


func _on_update_widget_button_pressed() -> void:
	task_container.set_container(database)
	

func _on_mostrar_data_button_pressed() -> void:
	var table: Array = database.select_rows(C.TABLE_NAME, "", ["*"])
	
	if table.size() == 0:
		print("No tasks added.")
		return
		
	for row in table:
		print("task: ", row[C.NAME], " -> ", row[C.DESCRIPTION], " :: ", row[C.END_DATE], " :: done ", row[C.DONE]) 


func _on_next_task_button_pressed() -> void:
	pass

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
