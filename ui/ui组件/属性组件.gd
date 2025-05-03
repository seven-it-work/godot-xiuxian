extends PanelContainer

@export var data:Dictionary={}

func _ready() -> void:
	pass

func _update(data:Dictionary):
	if data.is_empty():
		return
	if data.has("name_str"):
		$"HBoxContainer/name_str"._update(data.get("name_str"))
		pass
	if data.has("type_info"):
		var type_info = data.get("type_info")
		if type_info=="BarPropertie":
			$HBoxContainer/ProgressBar.visible=true
			$HBoxContainer/ProgressBar.min_value=data.get("min_v",0)
			$HBoxContainer/ProgressBar.max_value=data.get("max_v",0)
			$HBoxContainer/ProgressBar.value=data.get("current",0)
		elif type_info=="GrowthPropertie":
			$HBoxContainer/otherValue.visible=true
		elif type_info=="RandomPropertie":
			$HBoxContainer/randomValue.visible=true
			$HBoxContainer/randomValue._update("%.1f~%.1f"%[data.get("min_v",0),data.get("max_v",0)])
			
		else:
			Log.error("属性类型错误：%s"%type_info)
	pass

func _process(delta: float) -> void:
	pass
