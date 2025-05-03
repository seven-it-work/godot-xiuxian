extends Control

func _process(delta: float) -> void:
	pass

func 技能特效():
	var l=Label.new()
	l.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	l.text="攻击"
	add_child(l)
	var start_node=$VBoxContainer/Player/HBoxContainer/PanelContainer
	var end_node=$VBoxContainer/Enemy/HBoxContainer/PanelContainer
	var tween = create_tween()
	l.position.x=start_node.global_position.x+randf_range(0,start_node.size.x)
	l.position.y=start_node.global_position.y
	var end_position=Vector2(
		end_node.global_position.x+randf_range(0,end_node.size.x),
		end_node.global_position.y
	)
	tween.tween_property(
		l,                # 目标对象
		"position",    # 要动画的属性
		end_position,  # 目标位置
		1                  # 动画时长（秒）
	).set_ease(Tween.EASE_IN)
	# 动画结束后删除 Label
	tween.tween_callback(技能特效tween_callback)
	pass

func 技能特效tween_callback(node:Node,l:Label):
	l.queue_free()
	start_shake(node)
	pass

func start_shake(node:Node):
	var initial_position=node.position
	var shake_strength: float = 10.0    # 抖动强度（像素）
	var shake_speed: float = 30.0       # 抖动频率（值越大越快）
	var shake_duration: float = 1.0    # 抖动持续时间（秒）
	var tween = create_tween().set_loops()  # 无限循环
	var timer = get_tree().create_timer(shake_duration)  # 限制抖动时间
	# 抖动动画
	tween.tween_callback(
		func():
			# 随机方向偏移
			var random_offset = Vector2(
				randf_range(-shake_strength, shake_strength),
				randf_range(-shake_strength, shake_strength))
			node.position = initial_position + random_offset
	).set_delay(1.0 / shake_speed)  # 控制频率
	
	# 抖动结束后复位
	timer.timeout.connect(
		func():
			tween.kill()  # 停止抖动
			node.position = initial_position
	)


## todo 删除
func _on_button_pressed() -> void:
	技能特效()
	pass # Replace with function body.
