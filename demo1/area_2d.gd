extends Area2D

@export var vision_angle = 150  # 视野角度(度)
@export var vision_distance = 500  # 视野距离

@onready var light = $Light2D
@onready var occluder = $LightOccluder2D

func _ready():
	update_vision_shape()

func update_vision_shape():
	# 设置光照范围
	light.texture_scale = vision_distance / 100.0
	
	# 创建扇形遮罩
	var polygon = OccluderPolygon2D.new()
	polygon.polygon = _create_vision_polygon()
	occluder.occluder = polygon

func _create_vision_polygon() -> PackedVector2Array:
	var points = PackedVector2Array()
	var angle_range = deg_to_rad(vision_angle)
	var steps = 20  # 扇形平滑度
	
	points.append(Vector2.ZERO)  # 中心点
	
	for i in range(steps + 1):
		var angle = -angle_range/2 + (i * angle_range/steps)
		var dir = Vector2(cos(angle), sin(angle))
		points.append(dir * vision_distance)
	
	return points
