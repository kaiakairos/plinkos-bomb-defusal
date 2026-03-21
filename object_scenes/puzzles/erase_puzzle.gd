extends Puzzle

@onready var images :Texture2D = preload("res://object_scenes/puzzles/puzzleAssets/eraseImg.png")

var drawing:bool = false

var lastPos :Vector2i = Vector2i(-1,-1)

var img :Image
var totalPixels :int = 0

func _ready() -> void:
	initializeImage()

func _process(delta: float) -> void:
	$ColorRect2.modulate = game.gradient.sample(1.0 - (game.timer - float(int(game.timer))))

func initializeImage() -> void:
	var baseImg :Image = images.get_image()
	baseImg.convert(Image.FORMAT_RGB8)
	img = Image.create(32,32,false,Image.FORMAT_RGB8)
	
	img.blend_rect(baseImg,Rect2i(rand.randi_range(0,15) * 32,0,32,32),Vector2i.ZERO)
	setTextureFromImg()
	
	totalPixels = getRemainingPixels()
	print(totalPixels)
	
func setTextureFromImg() -> void:
	$Sprite2D.texture = ImageTexture.create_from_image(img)

func _input(event: InputEvent) -> void:
	if !puzzleEnabled:
		return
	if event is InputEventMouseButton:
		if event.button_index != 1:
			return
		
		drawing = event.pressed
		return
	
	if event is not InputEventMouseMotion:
		return
	
	if !drawing:
		return
	
	var mouse :Vector2 = $Sprite2D.get_local_mouse_position()
	var pixelPosition :Vector2i= Vector2i(mouse)
	if mouse.x < 0:
		pixelPosition.x -= 1
	if mouse.y < 0:
		pixelPosition.y -= 1
	
	if pixelPosition == lastPos:
		return
	lastPos = pixelPosition
	
	if clamp(pixelPosition.x,0,31) != pixelPosition.x:
		return
	if clamp(pixelPosition.y,0,31) != pixelPosition.y:
		return
	
	for x in range(5):
		for y in range(5):
			var pos :Vector2i = pixelPosition + Vector2i(x-2,y-2)
			if x == 0 and y == 0:
				continue
			if x == 4 and y == 4:
				continue
			if x == 0 and y == 4:
				continue
			if x == 4 and y == 0:
				continue
			if clamp(pos.x,0,31) != pos.x:
				continue
			if clamp(pos.y,0,31) != pos.y:
				continue
			img.set_pixelv(pos,Color.WHITE)
	
	setTextureFromImg()
	
	
	$sound.pitch_scale = randf_range(0.5,0.8)
	print(sin(game.timer * 10.0))
	$sound.play(0.0)
	
	var tilesLeft :int = getRemainingPixels()
	var percentile :float = 1.0 - (float(tilesLeft) / float(totalPixels))
	#print(totalPixels)
	$ColorRect2.size.x = percentile * 96.0
	if tilesLeft <= 0:
		winPuzzle()
		
func getRemainingPixels() -> int:
	var i :int = 0
	for x in range(32):
		for y in range(32):
			var color :Color = img.get_pixel(x,y)
			if color != Color.WHITE:
				i += 1
	return i
