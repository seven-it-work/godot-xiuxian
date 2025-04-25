extends Control

func _process(delta: float) -> void:
	var rect=get_viewport().get_visible_rect()
	$PanelContainer.size=rect.size
	pass

func _ready() -> void:
	# start game
	# init map
	for i in $AllData/MapList.get_children():
		print(i)
		var ui_temp=i.get_ui("EnterButton")
		ui_temp.visible=true
		$PanelContainer/Core/CoreMain/Map/GridContainer.add_child(ui_temp)
	pass

## 对核心布局进行场景切换
func change_core_tscn(tscn:String,initData):
	pass

func open_dialog(type:String,data=null,node:Node=null):
	pass
