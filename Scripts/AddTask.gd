extends Control

var C = Constants.new()
var database: SQLite


func _ready():
	database = SQLite.new()
	database.path = C.DATABASE_PATH
	database.open_db()
	_create_table()


func _create_table():
	database.create_table(C.TABLE_NAME, C.TABLE)


func _insert_data():
	var table = {
		C.START_DATE: Utils.get_current_day()
	}
	
	if $NameText.text != "":
		table[C.NAME] = $NameText.text
	else:
		print("Empty name.")
		
	if $DescriptionText.text != "":
		table[C.DESCRIPTION] = $DescriptionText.text
	else:
		print("Empty description.")
	
	if Utils.is_valid_date_format($EndDateText.text):
		table[C.END_DATE] = $EndDateText.text
	
	database.insert_row(C.TABLE_NAME, table)

func _on_insert_data_button_pressed() -> void:
	_insert_data()


func _on_select_data_button_pressed() -> void:
	print(database.select_rows(C.TABLE_NAME, "", ["*"]))


func _on_mostrar_data_button_pressed() -> void:
	var table: Array = database.select_rows(C.TABLE_NAME, "", ["*"])
	
	if table.size() == 0:
		print("No tasks added.")
		return
		
	for row in table:
		print("task: ", row[C.NAME], " -> ", row[C.DESCRIPTION], " :: ", row[C.END_DATE]) 
