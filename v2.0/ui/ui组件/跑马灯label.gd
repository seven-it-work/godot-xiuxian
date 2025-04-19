extends ScrollContainer
# 滚动速度
@export var scroll_speed: float = 0.033
@export var min_scroll_width: float = 60.0  # 滚动阈值
# 文字信息
@export var text:String=""

var _should_scroll: bool = false

func _ready() -> void:
	$Timer.start(scroll_speed)
	# 隐藏滚动条（两种方法任选其一）
	get_h_scroll_bar().visible = false          # 方法1：直接隐藏
	get_h_scroll_bar().modulate.a = 0
	await get_tree().create_timer(1.0).timeout
	print("After 1 second, scroll_horizontal:", scroll_horizontal)  # 如果仍为0，说明被外部重置
	init($HBoxContainer/Label.text)
	pass

func init(new_text: String):
	self.text=new_text
	$HBoxContainer/Label.text=new_text
	$HBoxContainer/bak.text=new_text
	_check_text_width()
	
	get_h_scroll_bar().visible = false          # 方法1：直接隐藏
	get_h_scroll_bar().modulate.a = 0


# 关键：检测文本是否需要滚动
func _check_text_width():
	var font = $HBoxContainer/Label.get_theme_font("font")
	var font_size = $HBoxContainer/Label.get_theme_font_size("font_size")
	var text_width = font.get_string_size($HBoxContainer/Label.text).x
	_should_scroll = text_width > min_scroll_width 
	if _should_scroll:
		tooltip_text=self.text
	print("Text Width:", text_width, " | Min Width:", min_scroll_width, " | Label Width:", size.x)
	print("Should Scroll:", _should_scroll)  # 必须输出 true 才会滚动


func _on_timer_timeout() -> void:
	if not _should_scroll:
		return
	scroll_horizontal += 1
	# 首尾循环判断
	if scroll_horizontal >= $HBoxContainer/Label.size.x+4:
		scroll_horizontal = 0
