class_name Utils extends Node

static func is_valid_date_format(date: String) -> bool:
	# Split date.
	var split_date: PackedStringArray = date.split("-")
	if split_date.size() != 3:
		print("Invalid format, expected: YYYY-MM-DD.")
		return false
	
	# Parse date data.
	var year := int(split_date[0])
	var month := int(split_date[1])
	var day := int(split_date[2])
	
	# Check year.
	if year < 1000 or year > 9999:
		print("Invalid year.")
		return false
	
	# Check month.
	if month < 1 or month > 12:
		print("Invalid month.")
		return false
	
	# Days per month.
	var days_in_month := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	
	# Adjust february.
	if is_leap_year(year):
		days_in_month[1] = 29
	
	# Check day.
	if day < 1 or day > days_in_month[month - 1]:
		print("Invalid day.")
		return false
	
	return true


static func is_leap_year(year: int) -> bool:
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)


static func get_current_day() -> String:
	# Get current day.
	var date_dict = Time.get_datetime_dict_from_system()
	
	# Convert it in YYYY-MM-DD format.
	var date_str = "%04d-%02d-%02d" % [
		date_dict.year,
		date_dict.month,
		date_dict.day
	]
	
	return date_str
