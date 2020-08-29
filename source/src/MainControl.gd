extends Control

export var max_character_limit := 120
onready var txtEdit := $LineEdit
onready var submit := $SubmitBtn
onready var error_text := $error_text
onready var scrollBox := $ScrollContainer
onready var anim_player := $AnimationPlayer
onready var vboxContainer := $ScrollContainer/VBoxContainer
onready var percentageCompletionLabel_text := $Panel/HBoxContainer/PercentageCompletionLabel_text
onready var totalTaskCountLabel_text := $Panel/HBoxContainer/TotalTaskCountLabel_text
onready var displayedTaskCountLabel_text := $Panel/HBoxContainer/DisplayedTaskCountLabel_text
onready var hiddenTaskCountLabel_text := $Panel/HBoxContainer/HiddenTaskCountLabel_text
onready var confirmaDialogue_delete := $ConfirmDialog_Delete
onready var manageTasksButton := $Panel/MenuButton_ManageTasks
var user_strings_arr = []
var date_arr = []
var dueDate_arr = []
var percentageSliderValue_arr = []
var itemIndex_arr = []
var itemIndex : int 
var savedIndex : int
onready var totalTaskCount : int 
onready var displayedTaskCount : int 
onready var hiddenTaskCount : int 
var popupswitch : String
var percentageSliderValue : int


func _ready():
	
	$Panel/MenuButton_ManageTasks.get_popup().add_item("Completed Tasks")
	$Panel/MenuButton_ManageTasks.get_popup().add_item("Inactive & Uncompleted Tasks")
	$Panel/MenuButton_ManageTasks.get_popup().add_item("All Inactive Tasks")
	$Panel/MenuButton_ManageTasks.get_popup().add_item("Selected Tasks")
	$Panel/MenuButton_ManageTasks.get_popup().add_item("All Tasks")
	
	$Panel/MenuButton_ManageTasks.get_popup().connect("id_pressed", self, "_on_item_pressed")
	
	$PopupMenu_CompletedTasks.add_check_item("Hide", 0, 0)
	$PopupMenu_CompletedTasks.add_check_item("Unhide", 1, 0)
	$PopupMenu_CompletedTasks.add_check_item("Delete", 2, 0)
	
	$PopupMenu_Inactive_Uncompleted_Tasks.add_check_item("Hide", 0, 0)
	$PopupMenu_Inactive_Uncompleted_Tasks.add_check_item("Unhide", 1, 0)
	$PopupMenu_Inactive_Uncompleted_Tasks.add_check_item("Delete", 2, 0)
	
	$PopupMenu_AllInactiveTasks.add_check_item("Hide", 0, 0)
	$PopupMenu_AllInactiveTasks.add_check_item("Unhide", 1, 0)
	$PopupMenu_AllInactiveTasks.add_check_item("Delete", 2, 0)
	
	$PopupMenu_SelectedTasks.add_check_item("Hide", 0, 0)
	$PopupMenu_SelectedTasks.add_check_item("Unhide", 1, 0)
	$PopupMenu_SelectedTasks.add_check_item("Delete", 2, 0)
	
	$PopupMenu_AllTasks.add_check_item("Hide", 0, 0)
	$PopupMenu_AllTasks.add_check_item("Unhide", 1, 0)
	$PopupMenu_AllTasks.add_check_item("Delete", 2, 0)
	
	
	if !SaveScript.is_file_there():
		itemIndex = 0	
	else:
		user_strings_arr = SaveScript.load_data_data()
		date_arr = SaveScript.load_date_data()
		dueDate_arr = SaveScript.load_dueDate_data()
		itemIndex_arr = SaveScript.load_itemIndex_data()
		for num in user_strings_arr.size():
			var new_block := preload("res://src/TemplateNode.tscn").instance()
			new_block.get_child(0).get_child(0).text = itemIndex_arr[num]
			new_block.get_child(0).get_child(1).text = user_strings_arr[num]
			new_block.get_child(0).get_child(2).text = date_arr[num]
			new_block.get_child(0).get_child(7).text = dueDate_arr[num]
			vboxContainer.add_child_below_node(vboxContainer.get_child(0), new_block)
			var tempIndex = itemIndex_arr[num]
			tempIndex = tempIndex.replace(".", "")
			itemIndex = int(tempIndex)
		countTasks()
	pass
	
func some_function():
	print("start")
	yield(get_tree().create_timer(20), "timeout")
	print("end")

	
func countTasks() -> void:
	var tasks = vboxContainer.get_children()
	var num = vboxContainer.get_child_count()
	var tempDisplayedCount : int 
	var tempHiddenCount : int 
	
	for task in tasks:
		if task != vboxContainer.get_child(0) && task.visible == true: 
			tempDisplayedCount += 1
			print("we can see these tasks")		
		elif task != vboxContainer.get_child(0) && task.visible == false:
			tempHiddenCount += 1
			print("we can't see these tasks")
		if task != vboxContainer.get_child(0):
			task.connect("percentageSliderValueChanged", self, "sumUpTaskPercentages") 
			
	totalTaskCount = num - 1
	totalTaskCountLabel_text.text = "Total Tasks: " + str(totalTaskCount)
	displayedTaskCount = tempDisplayedCount
	displayedTaskCountLabel_text.text = "Displayed Tasks: " + str(displayedTaskCount)
	hiddenTaskCount = tempHiddenCount
	hiddenTaskCountLabel_text.text = "Hidden Tasks: " + str(hiddenTaskCount)
		
			
			
			
func _on_item_pressed(id):
	var item_name = $Panel/MenuButton_ManageTasks.get_popup().get_item_text(id)
	if item_name == "Completed Tasks": 
		$PopupMenu_CompletedTasks.popup()	
		print(item_name + " was pressed")
	elif item_name == "Inactive & Uncompleted Tasks":
		$PopupMenu_Inactive_Uncompleted_Tasks.popup()
		print(item_name + " was pressed")		
	elif item_name == "All Inactive Tasks":
		$PopupMenu_AllInactiveTasks.popup()	
		print(item_name + " was pressed")
	elif item_name == "Selected Tasks":
		$PopupMenu_SelectedTasks.popup()	
		print(item_name + " was pressed")
	elif item_name == "All Tasks":
		$PopupMenu_AllTasks.popup()	
		print(item_name + " was pressed")
			
	

func _input(event: InputEvent) -> void:
	var temp1 : String = txtEdit.text
	if event.is_action_pressed("enter"):
		insert_text()
	
	if event.is_action_pressed("up") and !txtEdit.text == "" and vboxContainer.get_child_count() >1:
		txtEdit.text = vboxContainer.get_child(1).get_child(0).get_child(0).text
		vboxContainer.get_child(1).queue_free()
#	if event.is_action_pressed("r"):
#		get_tree().reload_current_scene()
#	if event.is_action_pressed("t"):
#		save_everything()


func _on_SubmitBtn_pressed() -> void:
	insert_text()
	countTasks()
	
	

func insert_text() -> void:
	var settable := true
	var new_text : String = txtEdit.text
	itemIndex += 1
	

	if new_text.length() >= max_character_limit:
		set_error_text("You exceded the max limit of " +  str(max_character_limit) + " characters. \n This modification helps you be more precise.")
	elif new_text.length() <= 0:
		set_error_text("You need to type some text, you can't leave it empty :(")
	else:
		
		var new_block := preload("res://src/TemplateNode.tscn").instance()
		var day_var : String = str(OS.get_date()["day"])
		var year_var : String = str(OS.get_date()["year"])
		var month_var : String = str(OS.get_date()["month"])
		new_block.get_child(0).get_child(0).text = str(itemIndex) + "."
		new_block.get_child(0).get_child(1).text = new_text
		new_block.get_child(0).get_child(2).text = ("Entry Date: " + day_var + "-" + month_var + "-" + year_var)
		
		
# NOTE THIS PORTION IS NOT APPLICABLE TO THE TASK APP. 
#IT IS LEFT HERE FOR REFERENCE FROM THE ORIGINAL PROJECT THE TASK APP IS BUILT ON AND WILL BE REMOVED OR REFACTORED LATER
#		Check if they said grateful 
		if !new_text.findn("grateful") == -1:
			set_error_text("""Please refrain from saying \"grateful\" or \"I am grateful\" as it helps with saving 
			and indexing all the texts. Alternatively, you can say \"my life, my family\", instead of 
			the entire grateful part. Please and thank you! """)
			settable = false
#			print("found grateful")
		else:
			pass
#			print(new_text.findn("grateful", 0))
#			print("no grateful put in") 
#			new_block.get_child(0).get_child(1).text = (new_text).to_lower()  #check back later to be sure if you need this or not



# NOTE THIS PORTION IS NOT APPLICABLE TO THE TASK APP. 
#IT IS LEFT HERE FOR REFERENCE FROM THE ORIGINAL PROJECT THE TASK APP IS BUILT ON AND WILL BE REMOVED OR REFACTORED LATER
#		Check if there is a similar text
		for texts in user_strings_arr:
			if texts.to_lower() == ("I am grateful for " + new_text).to_lower():
				set_error_text("Sorry, but you have already inputed this message")
				settable = false
#			var temp1 :String= str(texts.format(str(""), str("I am grateful for")))
#			print(temp1)
#			print(texts.erase(0,17))
			
		if settable:
			vboxContainer.add_child_below_node(vboxContainer.get_child(0), new_block)
			txtEdit.text = clear_text()
			save_everything()


func clear_text() -> String:
	var my_str := ""
	return my_str


func set_error_text(inputed_string : String) -> void:
	error_text.text = inputed_string
	anim_player.seek(0, true)
	anim_player.play("text_fade")
	pass



func _on_Control_tree_exiting() -> void:
	save_everything()
	pass


func save_everything() -> void:
	user_strings_arr.clear()
	date_arr.clear()
	dueDate_arr.clear()
	for child in vboxContainer.get_children():
		if child.is_in_group("ignore"):
			continue
		else:
			itemIndex_arr.push_front(child.get_child(0).get_child(0).text)
			user_strings_arr.push_front(child.get_child(0).get_child(1).text)
			date_arr.push_front(child.get_child(0).get_child(2).text)
			dueDate_arr.push_front(child.get_child(0).get_child(7).get_text())
#	print(user_strings_arr, date_arr)
	SaveScript.save_data(user_strings_arr, date_arr, dueDate_arr, itemIndex_arr)
	pass


func _on_Settings_control_erase_now() -> void:
	for child in vboxContainer.get_children():
		if child.is_in_group("ignore"):
			continue
		else:
			child.queue_free()



func _on_PopupMenu_CompletedTasks_id_pressed(id):
	if id == 0:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.percentage_slider.value == 100:	
				task.visible = false
	elif id == 1:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.percentage_slider.value == 100:
				task.visible = true
	elif id == 2:
		popupswitch = "completed"
		confirmaDialogue_delete.visible = true			
	countTasks()


func _on_PopupMenu_Inactive_Uncompleted_Tasks_id_pressed(id):
	if id == 0:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_button.is_pressed() == false && task.percentage_slider.value < 100:
				task.visible = false
	elif id == 1:
		var tasks = vboxContainer.get_children()
		var num = vboxContainer.get_child_count()
		print(num)
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_button.is_pressed() == false && task.percentage_slider.value < 100:	
				task.visible = true
	elif id == 2:
		popupswitch = "inactive_uncompleted"
		confirmaDialogue_delete.visible = true			
	countTasks()
	
	
func _on_PopupMenu_AllInactiveTasks_id_pressed(id):
	if id == 0:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_button.is_pressed() == false:
				task.visible = false
	elif id == 1:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_button.is_pressed() == false:	
				task.visible = true
	elif id == 2:
		popupswitch = "allInactive"
		confirmaDialogue_delete.visible = true			
	countTasks()


func _on_PopupMenu_SelectedTasks_id_pressed(id):
	if id == 0:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_box.is_pressed() == true:
				task.visible = false
		print("hide selected")
	elif id == 1:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_box.is_pressed() == true:
				task.visible = true
	elif id == 2:
		popupswitch = "selected"
		confirmaDialogue_delete.visible = true			
	elif id == 3:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_box.is_pressed() == true:
				task.due_date_label.text = task.date_obj.date()
	countTasks()

func _on_PopupMenu_AllTasks_id_pressed(id):
	if id == 0:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0):	
				task.visible = false
	elif id == 1:
		var tasks = vboxContainer.get_children()
		for task in tasks:
			if task != vboxContainer.get_child(0):	
				task.visible = true
	elif id == 2:
		popupswitch = "all"
		confirmaDialogue_delete.visible = true		
	countTasks()
	
		
func _on_ConfirmDialog_Delete_confirmed():
	var tasks = vboxContainer.get_children()
	if popupswitch == "all":
		for task in tasks:
			if task != vboxContainer.get_child(0): # Blank Node contained in VBoxContainer will throw error, so we exclude it		
				task.free()
	elif popupswitch == "selected":
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_box.is_pressed() == true:	
				task.free()
	elif popupswitch == "allInactive":
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_button.is_pressed() == false:	
				task.free()
	elif popupswitch == "inactive_uncompleted":
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.check_button.is_pressed() == false && task.percentage_slider.value < 100:		
				task.free()
	elif popupswitch == "completed":
		for task in tasks:
			if task != vboxContainer.get_child(0) && task.percentage_slider.value == 100:	
				task.free()
	countTasks()


func sumUpTaskPercentages():
	percentageSliderValue = 0
	var num = vboxContainer.get_child_count() - 1  # We subtract 1 to allow for the blank Node contained in VBoxContainer
	var tasks = vboxContainer.get_children()
	for task in tasks:
			if task != vboxContainer.get_child(0): # Blank Node contained in VBoxContainer will throw error, so we exclude it
				percentageSliderValue = percentageSliderValue + task.percentage_slider.value 
				percentageCompletionLabel_text.text = "Task Completion: " + str(percentageSliderValue / num) + "%"
				print(str(percentageSliderValue / num) + " is the total percentage")
	
	
