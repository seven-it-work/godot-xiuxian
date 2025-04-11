extends PanelContainer

# key=id,value=people
var all_people:Dictionary={}
var attack_queues:Array=[]
var is_player_turn:bool=true
var log_text:Array=[]
var pre_log_text_len:int=0;
var fightPlayer:PeopleFight

func _process(delta: float) -> void:
	if is_player_turn:
		return
	for i in all_people.values():
		i["label"].position.x=i["unit"]*i["data"].attack_speed_times
	if pre_log_text_len==log_text.size():
		return
	pre_log_text_len=log_text.size()
	$VBoxContainer/HBoxContainer/VBoxContainer/log_text.text=""
	for i in log_text:
		$VBoxContainer/HBoxContainer/VBoxContainer/log_text.text=$VBoxContainer/HBoxContainer/VBoxContainer/log_text.text+"i"+"\n"
	pass

func init(dic:Dictionary):
	GlobalInfo.is_pause=true
	var user_team=dic["user_team"]
	var target_team=dic["target_team"]
	all_people.clear()
	log_text.clear()
	for i in user_team:
		if is_instance_valid(i):
			i.attack_speed_times=i.attack_speed.get_current()
			var label=Label.new()
			label.text=i.name_str
			label.position.y=randf_range(0,$"VBoxContainer/集气列表".size.y-10)
			$"VBoxContainer/集气列表".add_child(label)
			all_people[i.id]={
				"is_user":true,
				"data":i,
				"unit":$"VBoxContainer".size.x/1.0/i.attack_speed_times,
				"label":label
			}
	
	for i in target_team:
		if is_instance_valid(i):
			i.attack_speed_times=i.attack_speed.get_current()
			var label=Label.new()
			label.text=i.name_str
			label.position.y=randf_range(0,$"VBoxContainer/集气列表".size.y-10)
			$"VBoxContainer/集气列表".add_child(label)
			all_people[i.id]={
				"is_user":false,
				"data":i,
				"unit":$"VBoxContainer".size.x/1.0/i.attack_speed_times,
				"label":label
			}
	_init_ui(user_team,target_team)
	_init_player_skill()
	# 玩家技能初始化
	is_player_turn=false
	pass

func _init_player_skill():
	$"VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/攻击".pressed.connect(user_skill.bind($"VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/攻击"))
	pass

func user_skill(skill:Skill):
	skill.use_skill(self.fightPlayer,null,$VBoxContainer/HBoxContainer/user_team.get_children(),$VBoxContainer/HBoxContainer/target_team.get_children())
	is_player_turn=false
	pass

func _init_ui(user_team:Array,target_team:Array):
	for i in $VBoxContainer/HBoxContainer/user_team.get_children():
		i.free()
	for i in user_team:
		var p=preload("res://ui/core/战斗界面/战斗人物介绍.tscn").instantiate()
		p.init(i)
		if i.is_player:
			fightPlayer=p;
		all_people[i.id]["fightPeople"]=p
		$VBoxContainer/HBoxContainer/user_team.add_child(p)
		
	for i in $VBoxContainer/HBoxContainer/target_team.get_children():
		i.free()
	for i in target_team:
		var p=preload("res://ui/core/战斗界面/战斗人物介绍.tscn").instantiate()
		p.init(i)
		all_people[i.id]["fightPeople"]=p
		$VBoxContainer/HBoxContainer/target_team.add_child(p)
	pass

func get_user_team()->Array:
	return all_people.values().filter(func(v:Dictionary): return v.get("is_user")).map(func(v): return v["data"])
	
func get_target_team()->Array:
	return all_people.values().filter(func(v:Dictionary): return !v.get("is_user")).map(func(v): return v["data"])

func _change_people_attack_speed(dic:Dictionary):
	var p:People=dic.get("data")
	if is_instance_valid(p):
		if p.attack_speed_times<=0:
			## 可以攻击，加入队列
			attack_queues.append(p.id)
			p.attack_speed_times=p.attack_speed.get_current()
			dic["unit"]=$"VBoxContainer".size.x/1.0/p.attack_speed_times
		else:
			p.attack_speed_times-=1

func do_action():
	if is_player_turn:
		$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer.show()
		return
	while true:
		if attack_queues.is_empty():
			break;
		var attacker:Dictionary=all_people[attack_queues.pop_front()]
		var fightPeople:PeopleFight=attacker["fightPeople"]
		if fightPeople.people.is_player:
			is_player_turn=true
			return
		else:
			log_text.append("【%s】进行攻击".format([fightPeople.people.name_str]))
			# ai执行
			GlobalInfo.all_skill.get_skill_by_id("attack").use_skill(fightPeople,null,$VBoxContainer/HBoxContainer/target_team.get_children(),$VBoxContainer/HBoxContainer/user_team.get_children())
			pass
	for i in all_people.values():
		_change_people_attack_speed(i)
	for i in $VBoxContainer/HBoxContainer/VBoxContainer/GridContainer.get_children():
		if i.has_method("do_action"):
			i.do_action()
	pass
