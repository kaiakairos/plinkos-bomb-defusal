extends Puzzle

var answer :int = 0

var inarow :int = 0

@export var gradient :Gradient

func _ready() -> void:
	generateMathPuzzles()

func _process(delta: float) -> void:
	$question/ColorRect.color = gradient.sample(1.0 - (game.timer - float(int(game.timer))))
	$MathCorrect.modulate.a = 1.0 - (sin( game.timer * PI * 2) * 0.3)

func generateMathPuzzles() -> void:
	var number1 :int = (rand.randi() % 20) - (rand.randi() % 20)
	var number2 :int = abs((rand.randi() % 20) - (rand.randi() % 20))
	
	var type :int = rand.randi() % 3
	var s :String = "+"
	
	match type:
		0: # addition
			answer = number1 + number2
			s = " + "
		1: # subtraction
			answer = number1 - number2
			s = " - "
		2: # multiplication
			answer = number1 * number2
			s = " x "
	
	if OS.has_feature("expo"):
		if answer > 28 or answer < 0:
			generateMathPuzzles() # if this is the expo version, we'll make it really easy
			return
	
	if answer > 50 or answer < -20:
		generateMathPuzzles() # reroll, keep the numbers small
		return
	
	$question/Label.text = str(number1) + s + str(number2) + " = ?"
	
	var answerButton :int = rand.randi() % 4
	for i in range(4):
		var label :Label
		match i:
			0: label = $answers/MathButton/Label
			1: label = $answers/MathButton2/Label
			2: label = $answers/MathButton3/Label
			3: label = $answers/MathButton4/Label
		
		if i == answerButton:
			label.text = str(answer)
			continue
		var r :int = rand.randi() % 2
		match r:
			0: label.text = str(answer + (rand.randi() % 10)  + 1 )
			1: label.text = str(answer - (rand.randi() % 10)  - 1 )


func _on_color_rect_gui_input(event: InputEvent) -> void:
	pressAnswer($answers/MathButton,0,int($answers/MathButton/Label.text),event,$answers/MathButton/Label)

func _on_color_rect_2_gui_input(event: InputEvent) -> void:
	pressAnswer($answers/MathButton2,1,int($answers/MathButton2/Label.text),event,$answers/MathButton2/Label)


func _on_color_rect_3_gui_input(event: InputEvent) -> void:
	pressAnswer($answers/MathButton3,2,int($answers/MathButton3/Label.text),event,$answers/MathButton3/Label)

func _on_color_rect_4_gui_input(event: InputEvent) -> void:
	pressAnswer($answers/MathButton4,3,int($answers/MathButton4/Label.text),event,$answers/MathButton4/Label)

func pressAnswer(button:Sprite2D,index:int,buttonAnswer:int,event: InputEvent, label:Label) -> void:
	if !puzzleEnabled:
		return
	if event is not InputEventMouseButton:
		return
	if event.button_index != 1:
		return
	if !event.pressed:
		return
	
	$click.play()
	
	
	if answer == buttonAnswer:
		inarow += 1
		
		if inarow == 3:
			winPuzzle()
		else:
			$right.play()
	else:
		inarow = 0
		$wrong.play()
	
	$MathCorrect.frame = inarow
	
	puzzleEnabled = false
	button.frame = 1
	label.position.y = -5
	label.self_modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	button.frame = 0
	label.position.y = -8
	label.self_modulate = Color.WHITE
	
	
	if inarow < 3:
		generateMathPuzzles()
		puzzleEnabled = true
