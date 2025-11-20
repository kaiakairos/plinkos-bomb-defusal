extends Puzzle

func _ready() -> void:
	$Label.text = str(rand.randi() % 10)

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if puzzleEnabled and event is InputEventMouseButton:
		winPuzzle()
