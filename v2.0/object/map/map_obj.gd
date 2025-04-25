extends Node
## 名称
@export var name_str=""

func _ready() -> void:
	init()
	pass

func init():
	$ui/EnterButton.text=name_str
	pass

func get_ui(key:String):
	var result=$ui.find_child(key).duplicate()
	return result
