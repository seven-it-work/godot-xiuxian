extends PanelContainer

@export var data:Property

const DATA_TYPE=preload("res://object/properties/properties.gd").DATA_TYPE

func _ready() -> void:
	pass

func init(data:Property):
	if data==null:
		return
	$"HBoxContainer/name_str".init(data.name_str)
	if data.data_type==DATA_TYPE.BAR:
		$HBoxContainer/ProgressBar.visible=true
		$HBoxContainer/ProgressBar.min_value=data.min_v
		$HBoxContainer/ProgressBar.max_value=data.max_v
		$HBoxContainer/ProgressBar.value=data.current_value
	elif data.data_type==DATA_TYPE.BASE:
		$HBoxContainer/otherValue.visible=true
	elif data.data_type==DATA_TYPE.RANDOM:
		$HBoxContainer/randomValue.visible=true
		$HBoxContainer/randomValue.init("%.1f~%.1f"%[data.min_v,data.max_v])
	else:
		Log.error("属性类型错误",data)

func _process(delta: float) -> void:
	pass
