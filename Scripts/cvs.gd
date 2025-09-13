extends Control

var doc = "res://Data/Tasks.csv"

func _ready() -> void:
	#$RichTextLabel.text = _read()
	pass

func _write() -> void:
	var file = FileAccess.open(doc, FileAccess.WRITE)
	
	var titles: Array[String] = ["Nombre", "Descripcion"]
	file.store_csv_line(titles, ";")
	
	var _name = $LineEdit.text
	var _description = $LineEdit2.text
	
	if _name != "" and _description != "":
		var data: Array[String] = [_name, _description]
		file.store_csv_line(data, ";")
	
	#print(file.get_as_text().split("\n").size())
	
	file.close()

func _read() -> Array:
	# Open file and read content.
	var file = FileAccess.open(doc, FileAccess.READ)
	var content = file.get_as_text()
	
	# Split content file and transform and erase empty slots.
	content = content.split("\n")
	var content_string = content as Array
	content_string.erase("")
	
	print(content_string.size())
	
	# Create and fill data Array.
	var data: Array = []
	for row in content_string:
		var new_row: Array = []
		row = row.split(";")
		for cell in row:
			new_row.append(cell)
		data.append(new_row)
	
	file.close()
	
	return data

func _on_button_pressed() -> void:
	print("Tarea gaurdada.")
	_write()
	#$RichTextLabel.text = _read()
	print(_read())
