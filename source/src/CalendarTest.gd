extends Control

# onready var dueDate := date_obj.date()
var dueDate 
signal selected_due_date(dueDate)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CalendarButton_date_selected(date_obj):
	dueDate = date_obj.date()
#	print(dueDate)
	print(date_obj.date())
	emit_signal("selected_due_date", dueDate)
#	var menuButton_dueDate = get_node("res://src/TemplateNode.tscn/CompletionLbl")
#	menuButton_dueDate.text = "Hello!"
	get_tree().change_scene("res://src/MainControl.tscn")
