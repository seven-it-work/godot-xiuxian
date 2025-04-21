extends Control

@export var speed: float = 30.0  # 移动速度

func _ready() -> void:
	pass

func init(text:String):
	$"跑马灯core".size=size
	
	$跑马灯core/Label.text = text
	$跑马灯core/bak.text = text
	# 等待一帧，让文字渲染
	await get_tree().process_frame
	$"跑马灯core".speed=speed
	if $跑马灯core/Label.size.x>size.x:
		tooltip_text=text
		$跑马灯core/bak.visible=true
		$"跑马灯core".start=true
	pass


func _on_gui_input(event: InputEvent) -> void:
	if $Window.visible:
		$Window.visible=false
		return
	if event is InputEventScreenTouch:
		# 触摸开始/结束
		if event.pressed:
			$Window.visible=true
			return
	if event is InputEventMouseButton:
		$Window.visible=true
		return
	$Window.visible=false
	pass # Replace with function body.

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			print("按键：", event.keycode)
			$Window.visible=false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			print("按键：", event.keycode)
			$Window.visible=false
	elif event is InputEventMouseButton:
		print("鼠标：", event.position)
		$Window.visible=false
	elif event is InputEventScreenTouch:
		$Window.visible=false
		return
