extends Control
class_name MainNode
## doaction的暂停判断
var puase:bool=false
## doaction的速度
var action_speed:int=1;

func _process(delta: float) -> void:
	var rect=get_viewport().get_visible_rect()
	$PanelContainer.size=rect.size
	pass

func is_puase()->bool:
	return puase;

func _ready() -> void:
	# start game
	# init map
	for i in $AllData/MapList.get_children():
		print(i)
		var ui_temp:Button=i.get_ui("MapTipsButton")
		ui_temp.visible=true
		$PanelContainer/Core/CoreMain/panle/Map.add_child(ui_temp)
	# 初始化人物，随机将人物分配到map中
	for i in $AllData/PeopleList.get_children():
		i.enter_map($AllData/MapList.get_children().pick_random())
	pass

## 对核心布局进行场景切换
func change_core_tscn(tscn:String,initData=null):
	for i in $PanelContainer/Core/CoreMain/panle.get_children():
		i.visible=false
	if StrUtils.is_blank(tscn):
		return
	var tscnNode=find_child(tscn)
	if tscnNode==null:
		Log.err("没有找到core节点",tscn)
		return
	tscnNode.visible=true
	if tscnNode.has_method("init"):
		tscnNode.init(initData)
	pass

func change_tips(tscn:String,initData=null):
	for i in $PanelContainer/Core/tips/panle.get_children():
		i.visible=false
	if StrUtils.is_blank(tscn):
		return
	var tscnNode=find_child(tscn)
	if tscnNode==null:
		Log.err("错误tips节点查询",tscn)
		return
	tscnNode.visible=true
	if tscnNode.has_method("init"):
		tscnNode.init(initData)
	pass

func open_dialog(type:String,data=null,node:Node=null):
	pass
