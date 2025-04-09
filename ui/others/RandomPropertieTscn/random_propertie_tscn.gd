@icon("res://asserts/组件图片/范围.png")
extends HBoxContainer

@export var 名称:String=""
@export var propertie:RandomPropertie

func _process(delta: float) -> void:
	$Label.text=名称
	if is_instance_valid(propertie):
		$value.text="%.1f~%.1f"%[propertie.min_v,propertie.max_v]
