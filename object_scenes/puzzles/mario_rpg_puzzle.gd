extends Puzzle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for button in $Buttons.get_children():
		button.frame = 0

func _physics_process(delta: float) -> void:
	for i in $Buttons.get_children():
		i.scale = lerp(i.scale,Vector2(1.0,1.0),0.2)


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if event.button_index != 1:
		return
	if !event.pressed:
		return
	if !puzzleEnabled:
		return
	
	var mousePos :Vector2 = $Buttons.get_local_mouse_position()
	var buttonIndex :int = (int(mousePos.x) / 42) + ((int(mousePos.y) / 42) * 3)
	
	if buttonIndex < 0 or buttonIndex >= 9:
		return # this should never happen, but i got a crash where it DID so just in case catch this
	
	var button :Sprite2D = $Buttons.get_child(buttonIndex)
	flipButton(button)
	
	if buttonIndex % 3 != 0:
		flipButton( $Buttons.get_child(buttonIndex - 1) )
	if buttonIndex % 3 != 2:
		flipButton( $Buttons.get_child(buttonIndex + 1) )
	if buttonIndex > 2:
		flipButton( $Buttons.get_child(buttonIndex - 3) )
	if buttonIndex < 6:
		flipButton( $Buttons.get_child(buttonIndex + 3) )
	
	$Click.position = get_local_mouse_position()
	$Click.pitch_scale = 1.0 + randf_range(-0.1,0.1)
	$Click.play()
	
	
	for i in $Buttons.get_children():
		if i.frame == 0:
			return
	winPuzzle()

func flipButton(buttonSprite:Sprite2D):
	buttonSprite.frame = abs(buttonSprite.frame - 1)
	buttonSprite.scale = Vector2(0.8,0.8)
