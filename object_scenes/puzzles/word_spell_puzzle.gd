extends Puzzle

var  words  :  Array[String] = ["shelf","meats","death","arbor","tubes","dials","peach","chain",
"crane","audio","sheet","nylon","nasty","feels","fleet","steal","bumps","phone","cramp","stamp",
"quick","taste","paste","brain","nails","fails","chain","plane","plain","match","spell","trail",
"trial","loved","waver","maker","water","paper","faker","label","table","chump","hater","house",
"leave","clean","fuzzy","wafer","gizmo","think","swing","toads","float","worms","flare","flail",
"steam","cheap","fumes","light","balls","haven","votes","books","error","eerie","speak","omega",
"shirt","phage","donut","court","apple","queen","zippy","drink","valor","forks","shade","order",
"ready","typed","words","agent","great","pacer","shout","hound","dough","trash","roast","fleas",
"bleak","treat","plead"]

var alphabet :String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

@export var gradient :Gradient

func _ready() -> void:
	
	$word.text = words[rand.randi() % words.size()].to_upper()
	
	for i in range(26):
		var ins :Sprite2D = Sprite2D.new()
		ins.texture = load("res://object_scenes/puzzles/puzzleAssets/buttonSmall.png")
		ins.hframes = 2
		ins.vframes = 26
		ins.position.y = (i/7) * 18
		ins.position.x = ((i%7) * 18) + (18 * int(ins.position.y > 40))
		ins.frame_coords.y = i
		
		$buttons.add_child(ins)
		
		
		var rect :ColorRect = ColorRect.new()
		rect.size = Vector2(18,18)
		rect.position = ins.position
		rect.color.a = 0.0
		rect.connect("gui_input",_on_color_rect_gui_input)
		$colorRects.add_child(rect)
func _process(delta: float) -> void:
	$word.modulate = gradient.sample(1.0 - (game.timer - float(int(game.timer))))
	$type.modulate = gradient.sample(1.0 - (((game.timer * 2.0) - float(int(game.timer * 2.0)) ) )  )
	$type.modulate.a *= 0.8
	$preview.scale = lerp($preview.scale,Vector2(1.0,1.0),0.2)

func appendLetter(index:int) -> void:
	$preview.text = $preview.text + alphabet[index]
	$preview.scale = Vector2(1.25,1.25)
	
	
	
	if $preview.text != $word.text.left($preview.text.length()): # incorrect letter selected
		$preview.text = ""
		$Error.play()
	
	$type.position.x = 80.0 +  ($preview.label_settings.font.get_string_size( $preview.text ).x / 2.0)
	if $preview.text == "":
		$type.position.x = 77.0
	
	var pitchBase :float = 1.0
	pitchBase = (($preview.text.length() - 1.0) * 0.05) + 1.0
	$Click.position = get_local_mouse_position()
	$Click.pitch_scale = pitchBase + randf_range(-0.1,0.1)
	$Click.play()
	
	if $preview.text == $word.text:
		winPuzzle()

func _on_color_rect_gui_input(event:InputEvent) -> void:
	
	if !puzzleEnabled:
		return
	
	if event is not InputEventMouseButton:
		return
	if event.button_index != 1:
		return
	if !event.pressed:
		return
	
	var mousePos :Vector2 = $colorRects.get_local_mouse_position()
	var index:int = 0
	for rect in $colorRects.get_children():
		var gulp :Vector2 = mousePos - rect.position
		if gulp.x < 18.0 and gulp.y < 18.0 and gulp.x >= 0.0 and gulp.y >= 0.0:
			
			appendLetter(index)
			
			var associatedbutton :Sprite2D= $buttons.get_child(index)
			print(associatedbutton)
			associatedbutton.frame_coords.x = 1
			await get_tree().create_timer(0.1).timeout
			associatedbutton.frame_coords.x = 0
			return
		index += 1
