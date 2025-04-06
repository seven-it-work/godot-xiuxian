extends HBoxContainer

@export var 名称:String=""

@export var propertie:BarPropertie

func _process(delta: float) -> void:
	$Label.text=名称
	if propertie:
		$ProgressBar.max_value=propertie.max_v
		$ProgressBar.min_value=propertie.min_v
		$ProgressBar.value=propertie.get_current()
