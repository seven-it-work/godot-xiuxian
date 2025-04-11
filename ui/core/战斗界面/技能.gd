@tool
class_name Skill
extends PanelContainer
## 全局唯一id
@export var id:String=""
## 技能描述
@export var description:String=""
## 技能名称
@export var name_str:String=""
## 技能冷却时间
@export var skill_cooldown:RandomPropertie
## 技能冷却时间计数器
var skill_cooldown_times:int=0;

## 获取集气速度
var people_attack_speed_callable:Callable

signal pressed

func _process(delta: float) -> void:
	if is_instance_valid(people_attack_speed_callable):
		var people_attack_speed=people_attack_speed_callable.call()
		
		pass

func do_action():
	skill_cooldown_times=maxi(skill_cooldown_times-1,0)
	pass

func _ready() -> void:
	$VBoxContainer/Button.text=self.name_str
	$VBoxContainer/RichTextLabel.text=self.description
	pass

## 使用技能
func use_skill(user:PeopleFight,target:PeopleFight,user_team:Array,target_team:Array):
	people_attack_speed_callable=_get_people_attack_speed.bind(user)
	if !skill_cooldown:
		Log.err("错误技能，没有冷却时间")
	skill_cooldown_times=skill_cooldown.get_current()
	skill_func(user,target,user_team,target_team)
	pass

## 由子类实现(技能处理逻辑)
func skill_func(user:PeopleFight,target:PeopleFight,user_team:Array,target_team:Array):
	pass



func _get_people_attack_speed(people:PeopleFight):
	return people.people.attack_speed


func _on_button_pressed() -> void:
	pressed.emit()
	pass # Replace with function body.
