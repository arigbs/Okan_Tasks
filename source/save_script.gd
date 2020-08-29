extends Node

var itemIndex_path := "user://itemIndex.dat"
var data_path := "user://sentences.dat"
var date_path := "user://date.dat"
var dueDate_path := "user://dueDate.dat"
var file := File.new()
var tempp := []


func save_data(arr_of_data : Array, arr_of_date : Array, arr_of_dueDate : Array, arr_of_itemIndex : Array):
	file.open(itemIndex_path, File.WRITE)
	file.store_var(arr_of_itemIndex)
	file.close()
	file.open(data_path, File.WRITE)
	file.store_var(arr_of_data)
	file.close()
	file.open(date_path, File.WRITE)
	file.store_var(arr_of_date)
	file.close()
	file.open(dueDate_path, File.WRITE)
	file.store_var(arr_of_dueDate)
	file.close()


func load_date_data() -> Array:
	var arr_of_date = []
	file.open(date_path, File.READ)
	arr_of_date = file.get_var()
	file.close()
	print(arr_of_date)
	return arr_of_date


func load_dueDate_data() -> Array:
	var arr_of_dueDate = []
	file.open(dueDate_path, File.READ)
	arr_of_dueDate = file.get_var()
	file.close()
	print(arr_of_dueDate)
	return arr_of_dueDate


func load_data_data() -> Array:
	var arr_of_data = []
	file.open(data_path, File.READ)
	arr_of_data = file.get_var()
	file.close()
	print(arr_of_data)
	return arr_of_data


func load_itemIndex_data() -> Array:
	var arr_of_itemIndex = []
	file.open(itemIndex_path, File.READ)
	arr_of_itemIndex = file.get_var()
	file.close()
	print(arr_of_itemIndex)
	return arr_of_itemIndex
	

func is_file_there() -> bool:
	var state : bool = false
	var temp1 : bool = false
	var temp2 : bool = false
	var temp3 : bool = false
	var temp4 : bool = false
	if file.file_exists(itemIndex_path):
		temp1 = true
	if file.file_exists(data_path):
		temp2 = true
	if file.file_exists(date_path):
		temp3 = true
	if file.file_exists(dueDate_path):
		temp4 = true
	if temp1 and temp2 and temp3 and temp4:
		state = true
#	print(state)
	return state
