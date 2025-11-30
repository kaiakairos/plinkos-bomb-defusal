extends Puzzle

var maze :Array[int] = []

var startingPos :Vector2 = Vector2.ZERO
var end :int = 0
var overwriteInput :bool = true

@export var gradient :Gradient

func _ready() -> void:
	generateMaze()
	$MazeBubble.position = startingPos + Vector2(30.0,30.0)

func _process(delta: float) -> void:
	$mazeSprite.modulate = gradient.sample(1.0 - (game.timer - float(int(game.timer))))

func _physics_process(delta: float) -> void:
	
	if !puzzleEnabled:
		return
	
	if !Input.is_action_pressed("mouse_left"):
		overwriteInput = false
	
	if overwriteInput:
		return 
	
	var mousePos :Vector2 = get_local_mouse_position()
	if mousePos.x != clamp(mousePos.x,0.0,150.0):
		return
	if mousePos.y != clamp(mousePos.y,0.0,150.0):
		return
	
	$MazeBubble.frame = int( Input.is_action_pressed("mouse_left") )
	
	if Input.is_action_just_pressed("mouse_left"):
		$click.position = get_local_mouse_position()
		$click.pitch_scale = 1.0
		$click.play()
	if Input.is_action_just_released("mouse_left"):
		$click.position = get_local_mouse_position()
		$click.pitch_scale = 0.6
		$click.play()
	
	if Input.is_action_pressed("mouse_left"):
		$MazeBubble.position = lerp($MazeBubble.position,mousePos,0.2)
		
		var tilePos :Vector2i = Vector2i( ($MazeBubble.position - Vector2(25.0,25.0)) / 10.0 )
		var index :int = tilePos.x + (tilePos.y * 10)
		
		if $MazeBubble.position.x <= 25.0 or $MazeBubble.position.y <= 25.0 or $MazeBubble.position.x >= 125.0 or $MazeBubble.position.x >= 125.0:
			reset()
			return
		
		if index > 99:
			reset()
			return
		
		if maze[index] == 0:
			reset()
		
		if maze[index] == 2:
			winPuzzle()

func reset() -> void:
	$Scary.show()
	$MazeBubble.hide()
	$MazeBubble.position = startingPos + Vector2(30.0,30.0)
	overwriteInput = true
	$scream.pitch_scale = randf_range(0.4,2.2)
	$scream.play()
	await get_tree().create_timer(0.25).timeout
	$scream.stop()
	$Scary.hide()
	$MazeBubble.show()

func generateMaze() -> void:
	
	for i in range(100):
		maze.append(0)
	
	var ungh :int = 0
	
	var logPosition :Vector2i = Vector2i(0,rand.randi()%10)
	var start :int = logPosition.x + (logPosition.y * 10)
	
	startingPos = logPosition * 10
	
	
	while(ungh < 99999):
		
		logPosition += Vector2i( Vector2(0,1).rotated((PI/2)*(rand.randi() % 4)) )
		logPosition.x = clamp(logPosition.x,0,9)
		logPosition.y = clamp(logPosition.y,0,9)
		if maze[logPosition.x + (logPosition.y * 10)] == 1:
			continue
		
		maze[logPosition.x + (logPosition.y * 10)] = 1
		if logPosition.x == 9:
			end = logPosition.x + (logPosition.y * 10)
			ungh = 9999999
		
		ungh += 1
	
	maze[start] = 3
	maze[end] = 2
	
	
	
	var img :Image = Image.create(10,10,false,Image.FORMAT_RGB8)
	for x in range(10):
		for y in range(10):
			match maze[x + (y * 10)]:
				0:
					img.set_pixel(x,y,Color.BLACK)
				1:
					img.set_pixel(x,y,Color.WHITE)
				2:
					img.set_pixel(x,y,Color.GREEN)
				3:
					img.set_pixel(x,y,Color.RED)
	
	$mazeSprite.texture = ImageTexture.create_from_image(img)
