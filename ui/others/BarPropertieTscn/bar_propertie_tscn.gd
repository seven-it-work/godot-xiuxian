@icon("res://asserts/组件图片/进度条.png")
extends HBoxContainer

@export var 名称:String=""

@export var propertie:BarPropertie

func _process(delta: float) -> void:
	$Label.text=名称
	if is_instance_valid(propertie):
		$ProgressBar.max_value=propertie.max_v
		$ProgressBar.min_value=propertie.min_v
		$ProgressBar.value=propertie.get_current()
