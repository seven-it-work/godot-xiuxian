extends Control

func _ready() -> void:
	var skill_path=["res://技能/攻击/攻击.tscn","res://技能/逃跑/逃跑.tscn"]
	for i in skill_path:
		GlobalInfo.all_skill.register(load(i).instantiate())
	
	GlobalInfo.start_new()
	GlobalInfo.player.weapon=Weapon.new().coverage_data_by_excel(1)
	GlobalInfo.player._save_in_bak()
	
	$"PanelContainer/VBoxContainer/玩家详情ui".init(GlobalInfo.player)
	
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
