class_name PeopleFight
extends PanelContainer

var people:People
var is_click:bool=false
@onready var not_select_panel=preload("res://ui/core/BattleUI/战斗人物介绍.tres")


func _ready() -> void:
	var style=get_theme_stylebox("panel").duplicate()
	add_theme_stylebox_override("panel",style)
	original_position=position
	pass

func init(people:People):
	self.people=people
	$VBoxContainer/HBoxContainer/VBoxContainer/人物名称.text = people.name_str
	if people.is_man: 
		$VBoxContainer/HBoxContainer/VBoxContainer/性别.text="性别：男" 
	else: 
		$VBoxContainer/HBoxContainer/VBoxContainer/性别.text="性别：女" 
	$VBoxContainer/生命值.propertie=people.hp
	$VBoxContainer/攻击力.propertie=people.atk
	$VBoxContainer/防御力.propertie=people.def
	$VBoxContainer/集气速度.propertie=people.attack_speed
	$VBoxContainer/逃跑概率.propertie=people.fight_escape_probability
	pass

			

######## 一些默认的动画 ########
var original_position:Vector2

## 被攻击时border的样式改变
@export_range(0,1) var be_attack_border_color:float=0:
	set(value):
		be_attack_border_color=value;
		var panel:StyleBoxFlat=get_theme_stylebox("panel")
		panel.border_color=Color.BLACK.lerp(Color.RED,be_attack_border_color)
		panel.set_border_width_all(lerpf(10,50,be_attack_border_color))
		add_theme_stylebox_override("panel",panel)
		
func be_attack_animation():
	# 被攻击动画
	# 抖动动画
	$AnimationPlayer.play("shake")
	await  get_tree().create_timer(1.0).timeout
	$AnimationPlayer.stop()
	position=original_position
	#var duration=1.0
	#var frequency=15.0
	#var strength=6.0
	#var elapsed=0.0
	#while  elapsed < duration:
		#var decay=1.0-(elapsed/duration)
		#position=original_position+Vector2(
			#randf_range(-strength,strength)*decay,
			#randf_range(-strength,strength)*decay,
		#)
		#await get_tree().process_frame
		#elapsed+=get_process_delta_time()
	#position=original_position
	pass
