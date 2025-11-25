extends Puzzle

var r :int = 0
var g :int = 0
var b :int = 0

var target :Vector3i = Vector3i.ZERO

const mult :float = 0.5

func _ready() -> void:
	target.x = rand.randi() % 3
	target.y = rand.randi() % 3
	target.z = rand.randi() % 3
	if target == Vector3i.ZERO:
		target.x = 1
	updateColors()


func updateColors() -> void:
	r = clamp(r,0,2)
	g = clamp(g,0,2)
	b = clamp(b,0,2)
	$targetColor.color = Color( mult * target.x, mult * target.y, mult * target.z )
	$currentColor.color = Color( mult * r, mult * g, mult * b )
	$values.text = ""
	
	
	# very cool script
	$values.text += "R "
	
	match r:
		0: $values.text += "000"
		1: $values.text += "050"
		2: $values.text += "100"
	
	$values.text += "\n"
	
	$values.text += "G "
	
	match g:
		0: $values.text += "000"
		1: $values.text += "050"
		2: $values.text += "100"
	
	$values.text += "\n"
	
	$values.text += "B "
	
	match b:
		0: $values.text += "000"
		1: $values.text += "050"
		2: $values.text += "100"
	
	$values.text += "\n"
	
	
	
	$values2.text = str(target.x) + "\n" + str(target.y) + "\n" + str(target.z) + "\n" 
	
	if r == target.x and g == target.y and b == target.z:
		winPuzzle()

func _process(delta: float) -> void:
	$values2.visible = game.timer < 2.0

func onButtonPressed(decreased:bool = false) -> void:
	$Click.pitch_scale = 1.0 + randf_range(-0.1,0.1)
	$Click.position = get_local_mouse_position()
	$Click.play()

func _on_increase_red_pressed() -> void:
	r += 1
	updateColors()
	onButtonPressed()

func _on_decrease_red_pressed() -> void:
	r -= 1
	updateColors()
	onButtonPressed(true)

func _on_increase_green_pressed() -> void:
	g += 1
	updateColors()
	onButtonPressed()

func _on_decrease_green_pressed() -> void:
	g -= 1
	updateColors()
	onButtonPressed(true)

func _on_increase_blue_pressed() -> void:
	b += 1
	updateColors()
	onButtonPressed()

func _on_decrease_blue_pressed() -> void:
	b -= 1
	updateColors()
	onButtonPressed(true)
