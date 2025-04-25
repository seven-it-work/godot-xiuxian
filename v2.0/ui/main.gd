extends Control

func _process(delta: float) -> void:
	var rect=get_viewport().get_visible_rect()
	print(rect)
	$ScrollContainer.size=rect.size
	pass

func _ready() -> void:
	var skill_path=["res://技能/攻击/攻击.tscn","res://技能/逃跑/逃跑.tscn"]
	for i in skill_path:
		GlobalInfo.all_skill.register(load(i).instantiate())
	
	GlobalInfo.start_new()
	GlobalInfo.player.weapon=Weapon.new().coverage_data_by_excel(1)
	GlobalInfo.player._save_in_bak()
	
	$"ScrollContainer/PanelContainer/VBoxContainer/玩家详情ui"._update(GlobalInfo.player)

	GlobalInfo.main_node=self
	#$寿命.propertie=people.max_life
	#$灵气值.propertie=people.lingqi
	#$吸收灵气量.propertie=people.lingqi_absorb
	#$吸收灵气冷却.propertie=people.lingqi_absorb_cool_time
	#$生命值.propertie=people.hp
	#$攻击力.propertie=people.atk
	#$防御力.propertie=people.def
	#$集气速度.propertie=people.attack_speed
	#$逃跑概率.propertie=people.fight_escape_probability
	#$怀孕周期.propertie=people.pregnancy
	#$动作速度.propertie=people.action_cool_time
	pass

## 对核心布局进行场景切换
func change_core_tscn(tscn:String,initData):
	pass

func open_dialog(type:String,data=null,node:Node=null):
	for i in $"Window/自定义".get_children():
		i.free()
	
	$"Window/自定义".hide()
	$"Window/地图点击ui".hide()
	$"Window/大地图".hide()
	if type=="自定义":
		if node==null:
			Log.error("参数错误")
		$"Window/自定义".add_child(node)
		if node.has_method("init"):
			node.init(data)
		$"Window/自定义".show()
		return
	if type=="地图点击ui":
		$"Window/地图点击ui".show()
		return
	if type=="大地图":
		$"Window/大地图".show()
		return
	pass
