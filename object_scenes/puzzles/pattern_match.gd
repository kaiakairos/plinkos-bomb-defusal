extends Puzzle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in $Buttons.get_children():
		button.frame = rand.randi() % 2
	for button in $Pattern.get_children():
		button.frame = (rand.randi() % 2) + 2


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
	checkIfButtonWin()

func checkIfButtonWin() -> void:
	
	for i in range(8):
		var button :Sprite2D = $Buttons.get_child(i)
		var pattern :Sprite2D = $Pattern.get_child(i)
		if button.frame_coords.x != pattern.frame_coords.x:
			return
	
	winPuzzle()
