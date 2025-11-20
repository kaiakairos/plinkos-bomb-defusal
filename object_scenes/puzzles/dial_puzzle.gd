extends Puzzle

var grabbing :bool = false
var source :float = 0.0

var number :float = 0.0

func _ready() -> void:
	number = rand.randf_range(-40.0,40.0)
	$target.text = "%.1f" % rand.randf_range(-40.0,40.0)
	$current.text = "%.1f" % number
	
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
	number -= before - $dial/base.rotation
	$current.text = "%.1f" % number


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
