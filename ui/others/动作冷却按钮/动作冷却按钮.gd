extends PanelContainer
@export var action_cool_times_callable:Callable
# 字符串备份
@export var text:String=""
# 是否展示自动
@export var is_show_auto_click:bool=true;
# 是否启用自动
@export var is_auto_click:bool=false
# 是否禁用
var disabled:bool=false
## 游戏暂停是否可以点击
@export var game_pause_can_click:bool=false
signal pressed

func init(action_cool_times_callable:Callable):
	self.action_cool_times_callable=action_cool_times_callable
	$HBoxContainer/Button.text=self.text
	if !self.is_show_auto_click:
		$"HBoxContainer/自动".hide()
	pass

func _ready() -> void:
	if !self.is_show_auto_click:
		$"HBoxContainer/自动".hide()

func _process(delta: float) -> void:
	if GlobalInfo.is_pause:
		if !game_pause_can_click:
			$HBoxContainer/Button.disabled=true
			return
	$HBoxContainer/Button.disabled=false
	$HBoxContainer/Button.text=self.text
	if !action_cool_times_callable:
		return
	if disabled:
		$HBoxContainer/Button.disabled=true
		return
	var re=action_cool_times_callable.call()
	if re>0:
		$HBoxContainer/Button.disabled=true
		$HBoxContainer/Button.text=self.text+"（剩余%.0f秒）"%action_cool_times_callable.call()
	else:
		if $"HBoxContainer/自动".visible:
			if self.is_auto_click && !$HBoxContainer/Button.disabled:
				pressed.emit()
		pass
	pass


func _on_button_pressed() -> void:
	pressed.emit()
	pass # Replace with function body.


func _on_自动_toggled(toggled_on: bool) -> void:
	self.is_auto_click=toggled_on
	if !action_cool_times_callable:
		pressed.emit()
		return
	pass # Replace with function body.
