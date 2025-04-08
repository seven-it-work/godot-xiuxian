extends HBoxContainer

@export var 名称:String=""
@export var propertie:RandomPropertie

func _process(delta: float) -> void:
	$Label.text=名称
	if propertie:
		$value.text="%.1f~%.1f"%[propertie.min_v,propertie.max_v]
