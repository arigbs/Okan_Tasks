extends Control

onready var itemIndex_label := $HBoxContainer/ItemIndexLbl
onready var user_comment := $HBoxContainer/UserCommentLbl
onready var date_label := $HBoxContainer/DateLbl
onready var due_date_label := $HBoxContainer/dueDateLbl
onready var completion_label := $HBoxContainer/CompletionLbl
onready var calendarButton_dueDate := $HBoxContainer/CalendarButton_DueDate
onready var menuButton_dueDate := $HBoxContainer/MenuButton_DueDate
onready var dueDateButton := $HBoxContainer/dueDateButton
onready var check_box := $HBoxContainer/CheckBox
onready var check_button := $HBoxContainer/CheckButton
onready var percentage_slider := $HBoxContainer/PercentageSlider
signal percentageSliderValueChanged
signal dueDate





func _ready():
	dueDateButton.connect("date_selected", self, "set_due_date")
	
	

func set_due_date(date_obj): 
	print(date_obj.date() + "calendar firing!") # Use the date_obj wisely :)
	self.dueDateButton.text = "Due Date: " + date_obj.date() 


	
func _on_Control_mouse_exited():
	pass # Replace with function body.

func _on_CheckBox_pressed():
	pass # Replace with function body.

# use this to toggle if the task is being actively worked on or not.
func _on_CheckButton_pressed():
	if check_button.is_pressed() == true: # white text in ON state
		user_comment.add_color_override("font_color", Color(128,128,128,1))	
		date_label.add_color_override("font_color", Color(128,128,128,1))	
		completion_label.add_color_override("font_color", Color(128,128,128,1))
				
	else:                                # deep red text in OFF state
		user_comment.add_color_override("font_color", Color(1,0,0,0.2))
		date_label.add_color_override("font_color", Color(1,0,0,0.2))
		completion_label.add_color_override("font_color", Color(1,0,0,0.2))
		

func _on_PercentageSlider_value_changed(value):
	completion_label.text = str(percentage_slider.value) + "% Complete"
	if percentage_slider.value == 100:
		user_comment.add_color_override("font_color", Color(0,1,0,1))	
		date_label.add_color_override("font_color", Color(0,1,0,1))	
		completion_label.add_color_override("font_color", Color(0,1,0,1))
		check_button.pressed = false
	else:
		user_comment.add_color_override("font_color", Color(128,128,128,1))	
		date_label.add_color_override("font_color", Color(128,128,128,1))	
		completion_label.add_color_override("font_color", Color(128,128,128,1))
		check_button.pressed = true
	
	emit_signal("percentageSliderValueChanged")
	

