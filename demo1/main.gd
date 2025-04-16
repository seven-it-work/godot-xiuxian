extends Node2D

# 视野范围
@export var view_radius: float = 200.0

func _ready():
	# 创建 Light2D
	var light = PointLight2D.new()
	light.texture = preload("res://demo1/light_mask.png")
	light.color = Color(1, 1, 1, 1)  # 白色
	light.energy = 1.0
	light.texture_scale = view_radius / 100.0  # 调整大小
	add_child(light)
	
	# 设置背景为黑色
	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 1)
	background.size = Vector2(1000, 1000)  # 设置背景大小
	add_child(background)
	background.z_index = -1  # 确保背景在最底层
	
	# 创建一些测试物品
	create_test_items()

func create_test_items():
	# 创建一些测试用的物品
	for i in range(10):
		var item = Sprite2D.new()
		item.texture = preload("res://asserts/组件图片/进度条.png")  # 你需要准备一个物品图片
		item.position = Vector2(randf_range(-400, 400), randf_range(-400, 400))
		add_child(item)

func _process(delta):
	# 让视野跟随鼠标
	var light = $Light2D
	if light:
		light.position = get_global_mouse_position()
