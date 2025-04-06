extends HBoxContainer

@export var 名称:String=""
@export var propertie:RandomPropertie

func _process(delta: float) -> void:
	$Label.text=名称
	if propertie:
		$value.text="%s~%s"%[propertie.min_v,propertie.max_v]
