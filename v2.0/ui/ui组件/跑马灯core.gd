extends HBoxContainer

@export var speed: float = 30.0  # 移动速度
var start:bool=false


func _process(delta):
	if !start:
		return
	# 移动文字
	position.x -= 30 * delta
	# 如果文字完全移出屏幕左侧
	if position.x + $Label.size.x < -4:
		# 重置位置到右侧
		position.x = 0
