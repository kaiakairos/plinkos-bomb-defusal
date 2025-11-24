extends Puzzle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in $Buttons.get_children():
		button.frame = rand.randi() % 2
	for button in $Pattern.get_children():
		button.frame = (rand.randi() % 2) + 2


func _process(delta: float) -> void:
	for i in $Buttons.get_children():
		i.scale = lerp(i.scale,Vector2(1.0,1.0),0.2)
	
	for button in $Pattern.get_children():
		button.modulate.a = 1.0 - (sin( (button.get_index() * 20.0) + (game.timer * PI)) * 0.5)
	
	for button in $Buttons.get_children():
		button.modulate.a = 1.0 - (sin( ((button.get_index() - 6.0) * 20.0) + (game.timer * PI)) * 0.5)
	
	
func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if event.button_index != 1:
		return
	if !event.pressed:
		return
	
	var mousePos :Vector2 = $Buttons.get_local_mouse_position()
	var buttonIndex :int = (int(mousePos.x) / 32) + ((int(mousePos.y) / 32) * 4)
	var button :Sprite2D = $Buttons.get_child(buttonIndex)
	button.frame = abs(button.frame - 1)
	button.scale = Vector2(0.8,0.8)
	checkIfButtonWin()
	$Click.position = get_local_mouse_position()
	$Click.pitch_scale = 1.0 + randf_range(-0.1,0.1)
	$Click.play()

func checkIfButtonWin() -> void:
	
	for i in range(8):
		var button :Sprite2D = $Buttons.get_child(i)
		var pattern :Sprite2D = $Pattern.get_child(i)
		if button.frame_coords.x != pattern.frame_coords.x:
			return
	
	winPuzzle()
