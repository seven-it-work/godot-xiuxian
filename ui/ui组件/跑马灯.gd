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
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		$Window.visible=false
		return
	if event is InputEventScreenTouch:
		$Window.visible=false
		return
	$Window.visible=false
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		$Window.visible=true
		$Window.position=event.global_position
		return
	if event is InputEventScreenTouch:
		$Window.visible=true
		$Window.position=event.position
		return
