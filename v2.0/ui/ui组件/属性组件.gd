extends PanelContainer

@export var data:Dictionary={}

func init(data:Dictionary):
	if data.is_empty():
		return
	if data.has("name_str"):
		$"HBoxContainer/跑马灯label".init(data.get("name_str"))
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
			print("%.1f~%.1f"%[data.get("min_v",0),data.get("max_v",0)])
			$HBoxContainer/randomValue.init("%.1f~%.1f"%[data.get("min_v",0),data.get("max_v",0)])
			
		else:
			Log.error("属性类型错误：%s"%type_info)
	pass

func _process(delta: float) -> void:
	pass
