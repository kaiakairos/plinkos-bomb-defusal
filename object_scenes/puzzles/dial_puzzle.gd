extends Puzzle

var grabbing :bool = false
var source :float = 0.0

var number :float = 0.0
var targetNumber :float = 0.0

var displayNumber :float = 0.0

func _ready() -> void:
	number = rand.randf_range(-40.0,40.0)
	targetNumber =  (number + rand.randf_range(-15.0,15.0))
	
	displayNumber = number
	$target.text = "%.1f" % targetNumber
	$current.text = "%.1f" % displayNumber
	
	$dial/base.rotation = lerp_angle($dial/base.rotation, -source,1.0)
	

func _process(delta: float) -> void:
	if !grabbing:
		return
	
	var mousePos :Vector2 = $dial.get_local_mouse_position()
	if !Input.is_action_pressed("mouse_left"):
		grabbing = false
		if $target.text == $current.text:
			winPuzzle()
			return
	
	var before :float = $dial/base.rotation
	$dial/base.rotation = lerp_angle($dial/base.rotation,mousePos.angle() - source,1.0)
	$dial/DialTop.rotation = $dial/base.rotation
	$dial/shade.rotation = $dial/base.rotation
	$dial/base/DialShadow.rotation = $dial/base.rotation * -1
	
	number -= (before - $dial/base.rotation) * 0.5
	displayNumber = number
	if OS.has_feature("expo"):
		if abs(number - targetNumber) < 0.3:
			displayNumber = targetNumber
	var newText :String = "%.1f" % displayNumber
	if newText != $current.text:
		var basePitch :float = 0.6
		if abs(targetNumber - number) < 1.0:
			basePitch = 0.8
		if abs(targetNumber - number) < 0.2:
			basePitch = 1.0
		$DialTick.pitch_scale = basePitch + randf_range(-0.1,0.1)
		$DialTick.play()
	$current.text = newText


func _on_dial_selector_gui_input(event: InputEvent) -> void:
	if !puzzleEnabled:
		return
	if event is not InputEventMouseButton:
		return
	if event.button_index != 1:
		return
	if !event.pressed:
		return
	grabbing = true
	var mousePos :Vector2 = $dial.get_local_mouse_position()
	source = mousePos.angle() - $dial/base.rotation
