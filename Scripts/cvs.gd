extends Control

const doc: String = "res://Data/Tasks.csv"

func _ready() -> void:
	#$RichTextLabel.text = _read()
	pass

func _write() -> void:
	var previous_data = _read()
	var file = FileAccess.open(doc, FileAccess.READ_WRITE)
	
	print("Size: ", previous_data.size())
	if previous_data.size() <= 0:
		var titles: Array[String] = ["Nombre", "Descripcion"]
		file.store_csv_line(titles, ";")
	
	var _name: String = $LineEdit.text
	var _description: String = $LineEdit2.text
	
	if _description.is_empty(): _description = "No hay descripcion."
	
	if _name != "":
		for row in previous_data:
			file.store_csv_line(row, ";")
		var new_data: Array[String] = [_name, _description]
		file.store_csv_line(new_data, ";")
	
	file.close()

func _read() -> Array:
	# Open file and read content.
	var file = FileAccess.open(doc, FileAccess.READ)
	var content = file.get_as_text()
	
	# Split content file and transform and erase empty slots.
	content = content.split("\n")
	var content_string: Array = content as Array
	content_string.erase("")
	
	# Create and fill data Array.
	var data: Array = []
	for row in content_string:
		var new_row: Array = []
		row = str(row).strip_edges(true, true) # Delete all no printable characters.
		row = row.split(";")
		
		for cell in row:
			if cell == "": continue
			new_row.append(cell)
		if new_row.size() == 0: continue
		data.append(new_row)
	
	file.close()
	
	return data

func _on_button_pressed() -> void:
	print("Tarea gaurdada.")
	_write()
	#$RichTextLabel.text = _read()
	print(_read())
