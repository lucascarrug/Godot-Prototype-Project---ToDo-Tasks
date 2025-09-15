extends Control

var database: SQLite

func _ready():
	database = SQLite.new()
	database.path = "res://Data/data.db"
	database.open_db()


func _on_create_table_button_pressed() -> void:
	var table = {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name": {"data_type": "text"},
		"score": {"data_type": "int"}
	}
	
	# TableName and Table
	database.create_table("Testing", table)


func _on_insert_data_button_pressed() -> void:
	var data = {
		"name": $NameTextEdit.text,
		"score": int($ScoreTextEdit.text)
	}

	database.insert_row("Testing", data)


func _on_select_data_button_pressed() -> void:
	print(database.select_rows("Testing", "", ["*"]))


func _on_update_data_button_pressed() -> void:
	#var row_data_to_update = {"score": int($ScoreTextEdit.text)}
	var row_data_to_update = {"name": "Gonzalo"}
	database.update_rows("Testing", "name = '" + $NameTextEdit.text + "'", row_data_to_update)


func _on_delete_data_button_pressed() -> void:
	database.delete_rows("Testing", "name = '" + $NameTextEdit.text + "'")


func _on_custom_select_button_pressed() -> void:
	pass # Replace with function body.
