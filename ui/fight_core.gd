extends Control

func _process(delta: float) -> void:
	pass

func 技能特效(特效node:Node):
	特效node.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	add_child(特效node)
	var start_node=$VBoxContainer/Player/HBoxContainer/PanelContainer
	var end_node=$VBoxContainer/Enemy/HBoxContainer/PanelContainer
	var tween = create_tween()
	特效node.position.x=start_node.global_position.x+randf_range(0,start_node.size.x-特效node.size.x)
	特效node.position.y=start_node.global_position.y
	var end_position=Vector2(
		end_node.global_position.x+randf_range(0,end_node.size.x-特效node.size.x),
		end_node.global_position.y+50
	)
	tween.tween_property(
		特效node,                # 目标对象
		"position",    # 要动画的属性
		end_position,  # 目标位置
		1                  # 动画时长（秒）
	).set_ease(Tween.EASE_IN)
	# 动画结束后删除 Label
	tween.tween_callback(技能特效tween_callback.bind(end_node,特效node))
	pass

func 技能特效tween_callback(node:Node,l:Node):
	l.queue_free()
	AnimationUtils.start_shake(self,node)
	AnimationUtils.transition_border_color(node,Color.RED,Color(0.8, 0.8, 0.8))
	AnimationUtils.transition_background_color(node,Color(1, 0.8, 0.8) ,Color(0.6, 0.6, 0.6))
	pass

const SWORD_TEXTURE = preload("res://asserts/其他未分类/剑.png")

## todo 删除
func _on_button_pressed() -> void:
	var l=TextureRect.new()
	l.texture=SWORD_TEXTURE
	技能特效(l)
	pass # Replace with function body.
