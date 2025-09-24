extends Control

const doc: String = "res://Data/Tasks.csv"

func _ready() -> void:
	pass

func _write() -> void:
	# Read file and open it in write mode.
	var previous_data: Array = _read()
	var file = FileAccess.open(doc, FileAccess.WRITE)
	
	# Add titles if don't exist.
	if previous_data.size() <= 0:
		var titles: Array[String] = ["ID", "Nombre", "Descripcion"]
		file.store_csv_line(titles, ";")
	
	# Capture inputs.
	var _id: String = str(ResourceUID.create_id())
	var _name: String = $LineEdit.text
	var _description: String = $LineEdit2.text
	
	# Fill cells.
	if _description.is_empty(): _description = "No hay descripcion."
	
	# Required fields condition and add task data.
	if _name == "":
		print("No task has been added.")
		file.close()
		return
		
	for row in previous_data:
		file.store_csv_line(row, ";")
	var new_data: Array[String] = [_id, _name, _description]
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
	print("New task added.")
	
	return data

func _delete_by_id(id_to_delete: String) -> void:
	# Read data.
	var previous_data: Array = _read()
	var has_deleted: bool = false
	
	# Find task.
	for task in previous_data:
		if task.get(0) == id_to_delete:
			previous_data.erase(task)
			has_deleted = true
			print("Task with id [", id_to_delete, "] has been deleted.")
			
	if not has_deleted:
		print("No task has been deleted.")
	
	# Open file in write mode.
	var file = FileAccess.open(doc, FileAccess.WRITE)
	
	# Rewrite new data.
	for task in previous_data:
		var new_data: Array[String] = [task[0], task[1], task[2]]
		file.store_csv_line(new_data, ";")


func _on_save_button_pressed() -> void:
	_write()


func _on_delete_button_pressed() -> void:
	_delete_by_id("2643383200449524125")


func _on_read_button_pressed() -> void:
	print(_read())
