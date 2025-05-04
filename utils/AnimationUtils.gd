extends Node
class_name AnimationUtils

## 开始抖动动画
static func start_shake(parent:Node,node:Node):
	var initial_position=node.position
	var shake_strength: float = 4.0    # 抖动强度（像素）
	var shake_speed: float = 30.0       # 抖动频率（值越大越快）
	var shake_duration: float = 0.5    # 抖动持续时间（秒）
	var tween = parent.create_tween().set_loops()  # 无限循环
	var timer = parent.get_tree().create_timer(shake_duration)  # 限制抖动时间
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


# 修改背景颜色
static func set_background_color(node:PanelContainer,color: Color):
	var style_box = node.get_theme_stylebox("panel").duplicate()
	
	if style_box is StyleBoxFlat:
		style_box.bg_color = color  # 修改背景色
		node.add_theme_stylebox_override("panel", style_box)
	else:
		# 如果默认不是 StyleBoxFlat，创建新的
		var new_style = StyleBoxFlat.new()
		new_style.bg_color = color  # 设置背景色
		new_style.border_width_left = 0  # 可选：去掉边框
		node.add_theme_stylebox_override("panel", new_style)

# 可选：添加渐变过渡效果（使用 Tween）
static func transition_background_color(node:PanelContainer,from: Color, to: Color, duration: float = 1.0):
	var tween = node.create_tween()
	tween.tween_method(
		func(color): set_background_color(node,color),
		from,
		to,
		duration
	)

# 渐变改变颜色
static func transition_border_color(panel:PanelContainer,from: Color, to: Color, duration: float = 1.0):
	var tween = panel.create_tween()
	tween.tween_method(
		func(color): set_border_color(panel,color), 
		from, 
		to, 
		duration
	)


# 设置边框颜色的方法
static func set_border_color(panel:PanelContainer,color: Color):
	# 获取或创建新的StyleBoxFlat
	var style_box = panel.get_theme_stylebox("panel").duplicate()
	# 确保是StyleBoxFlat类型
	if style_box is StyleBoxFlat:
		style_box.border_color = color
		# 应用新的样式
		panel.add_theme_stylebox_override("panel", style_box)
	else:
		# 如果默认不是StyleBoxFlat，创建一个新的
		var new_style = StyleBoxFlat.new()
		new_style.bg_color = Color(0, 0, 0, 0) # 透明背景
		new_style.border_color = color
		new_style.border_width_left = 2
		new_style.border_width_right = 2
		new_style.border_width_top = 2
		new_style.border_width_bottom = 2
		panel.add_theme_stylebox_override("panel", new_style)
