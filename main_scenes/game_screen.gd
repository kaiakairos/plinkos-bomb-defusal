extends Node2D
class_name GameScreen

var puzzles :Array[String] = [
	#"res://object_scenes/puzzles/test_puzzle.tscn",
	
	"res://object_scenes/puzzles/pattern_match.tscn",
	"res://object_scenes/puzzles/word_spell_puzzle.tscn",
	"res://object_scenes/puzzles/dial_puzzle.tscn",
	"res://object_scenes/puzzles/color_match_puzzle.tscn",
	"res://object_scenes/puzzles/mario_rpg_puzzle.tscn",
	"res://object_scenes/puzzles/scary_maze.tscn",
	"res://object_scenes/puzzles/baldis_basics_puzzle.tscn",
	"res://object_scenes/puzzles/erase_puzzle.tscn"
	
	
]

# leave empty for main game
var puzzleDebug :String = ""#"res://object_scenes/puzzles/erase_puzzle.tscn"

var timerTicking :bool = false
var timer :float = 20.0

var puzzlesWon :int = 0

var randomGenerator :RandomNumberGenerator = RandomNumberGenerator.new()

var lost :bool = false
var explosionRange :float = 0.0

var clicks :int = 1

@export var gradient :Gradient

func _ready() -> void:
	connectLids()
	var coolNewSeed :int = randi()
	if Global.setSeed != 0:
		coolNewSeed = Global.setSeed
		$Menu/Label4.text = Global.getDayString()
	generatePuzzles(coolNewSeed)

func generatePuzzles(randomSeed:int) -> void:
	randomGenerator.seed = randomSeed
	var puzzlesAdded :Array[String] = []
	for i in range(4):
		var r :int = randomGenerator.randi() % puzzles.size()
		var s :String = puzzles[r]
		var cycles :int = 0 # limit amount of cycles so we don't get stuck for too long here
		while( puzzlesAdded.has(s) and cycles < 8 ):
			r  = randomGenerator.randi() % puzzles.size()
			s  = puzzles[r]
			cycles += 1
		if puzzleDebug != "" and OS.has_feature("debug"):
			s = puzzleDebug
		var ins :Puzzle = load(s).instantiate()
		ins.position.x = (i % 2) * 150
		ins.position.y = (i / 2) * 150
		ins.puzzleID = i
		ins.connect("puzzleComplete",puzzleWon)
		ins.rand = randomGenerator
		ins.game = self
		$puzzles.add_child(ins)
		puzzlesAdded.append(puzzles[r])

func connectLids() -> void:
	for border in $borders.get_children():
		border.connect("opened",lidOpened)

func lidOpened(lid:PuzzleBorder):
	if !timerTicking:
		$Music.play()
		anims()
	timerTicking = true
	$puzzles.get_child(lid.id).enablePuzzle()

func _process(delta: float) -> void:
	
	
	if timerTicking:
		tickTimer(delta)
		if Input.is_action_just_pressed("mouse_left"):
			clicks += 1
	
	if lost:
		position.x = randf_range(-1.0,1.0) * explosionRange
		position.y = randf_range(-1.0,1.0) * explosionRange
		explosionRange = move_toward(explosionRange,0.0,0.4 * delta)
	
	$TimerBar/ColorRect/timeProgress.modulate = gradient.sample(1.0 - (timer - float(int(timer))))
	$TimerBar/ColorRect/timeProgress.position.y = 146.0 - (timer * (146.0 / 20.0))
	$TimerBar/NinePatchRect/flash.modulate.a =  (timer - float(int(timer))) * 0.7
	$TimerBar/NinePatchRect/flash.position.y = -8 +  146.0 - (timer * (146.0 / 20.0))
	
	var i :float = sin( Time.get_ticks_msec()  * 0.02) * 0.02
	$Menu/NewRecord.scale = Vector2(i + 0.9,i + 0.9)
	$Menu/NewRecord.rotation = (sin( Time.get_ticks_msec()  * 0.01) * 0.04) + -0.25
	
func tickTimer(delta:float) -> void:
	timer -= delta
	if timer < 0.0:
		timer = 0.0
		lose()
		timerTicking = false
	var labelText :String = "%.2f" % timer
	if timer < 10.0:
		labelText = "0" + labelText
	labelText = labelText.left(5)
	$Timer.text = labelText
	

func anims():
	$PlinkoPortrait.setAnim("work1")
	await get_tree().create_timer(8.0).timeout
	if !timerTicking:
		return
	$PlinkoPortrait.setAnim("work2")
	await get_tree().create_timer(8.0).timeout
	if !timerTicking:
		return
	$PlinkoPortrait.setAnim("work3")
	await get_tree().create_timer(3.0).timeout
	if !timerTicking:
		return
	$PlinkoPortrait.setAnim("work4")

func puzzleWon(puzzleScene:Puzzle) -> void:
	puzzlesWon += 1
	print("Puzzle " + str(puzzleScene.puzzleID) + " won!")
	$borders.get_child(puzzleScene.puzzleID).disablePuzzle()
	if puzzlesWon >= 4:
		timerTicking = false
		win()

func lose() -> void:
	lost = true
	for puzzle in $puzzles.get_children():
		puzzle.puzzleEnabled = false
	$ExplosionEffect.show()
	$PlinkoPortrait.setAnim("burnt")
	explosionRange = 2.0
	
	$Explosion.play()
	
	if Global.setSeed == 0:
		Global.totalTimesLost += 1
		Global.save()
	
	
	Ngio.request("Medal.unlock", {"id": 87367})
	
	await get_tree().create_timer(1.0).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($ExplosionEffect/ColorRect,"color:a",0.0,4.0)
	await get_tree().create_timer(4.0).timeout
	$Menu.show()
	$DeadMusic.play()
	

func win() -> void:
	
	if lost:
		return # incase of events where the player lost and won on the same frame, should always lose first
	
	
	$PlinkoPortrait.setAnim("win")
	
	var tween = get_tree().create_tween()
	tween.tween_property($Music,"pitch_scale",0.01,1.0)
	await tween.finished
	$Music.stop()
	
	await get_tree().create_timer(1.0).timeout
	$Menu.show()
	
	$Menu/Label.show()
	
	#var labelText :String = "%.2f" % (20.0 - timer)
	#if (20.0 - timer) < 10.0:
	#	labelText = "0" + labelText
	#labelText = labelText.left(5)
	
	$Menu/Label2.text = "TIME REMAINING: " + $Timer.text + "\nCLICKS: " +  str(clicks)
	
	$Menu/Label2.show()
	
	$WinMusic.play()
	
	if timer > Global.personalRecord and Global.setSeed == 0:
		$Menu/NewRecord.show()
		Global.personalRecord = timer
	
	if Global.setSeed == 0:
		# regular high score
		var labelText2 :String = "%.2f" % Global.personalRecord
		if Global.personalRecord < 10.0:
			labelText2 = "0" + labelText2
		labelText2 = labelText2.left(5)
		
		$Menu/Label3.text = "high score: " + labelText2 + " remaining"
		Global.totalTimesWon += 1
		if clicks < Global.bestClicks:
			Global.bestClicks = clicks
			# SCOREBOARD CLICKS HERE
		
		
		# only unlock medals in random mode
		Ngio.request("Medal.unlock", {"id": 87368})
		if timer < 1.0:
			Ngio.request("Medal.unlock", {"id": 87369})
		if timer > 10.0:
			Ngio.request("Medal.unlock", {"id": 87370})
		
		if Global.totalTimesWon >= 10:
			Ngio.request("Medal.unlock", {"id": 87371})
		if Global.totalTimesWon >= 100:
			Ngio.request("Medal.unlock", {"id": 87372})
		
		if clicks <= 15:
			Ngio.request("Medal.unlock", {"id": 87373})
		
		Ngio.request("ScoreBoard.postScore", {"id": 15370, "value": int(timer * 1000)})
		Ngio.request("ScoreBoard.postScore", {"id": 15371, "value": clicks})
		Ngio.request("ScoreBoard.postScore", {"id": 15372, "value": 1})
		
	else:
		# daily high score
		if Global.lastDayPlayed != Global.setSeed:
			Global.lastDayPlayed = Global.setSeed
			Global.bestDayTime = 0.0
		
		if timer > Global.bestDayTime:
			$Menu/NewRecord.show()
			Global.bestDayTime = timer
		
		var labelText2 :String = "%.2f" % Global.bestDayTime
		if Global.bestDayTime < 10.0:
			labelText2 = "0" + labelText2
		labelText2 = labelText2.left(5)
		
		$Menu/Label3.text = "best score today: " + labelText2 + " remaining"
	
	$Menu/Label3.show()
	
	Global.save()


func _on_retry_button_pressed() -> void:
	SceneTransitioner.transitionScene("res://main_scenes/game_screen.tscn")

func _on_quit_button_pressed() -> void:
	if OS.has_feature("web"):
		return
	get_tree().quit()

func _on_back_to_menu_button_pressed() -> void:
	SceneTransitioner.transitionScene("res://ui_scenes/mainMenu/main_menu.tscn")
