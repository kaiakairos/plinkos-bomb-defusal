extends Node2D


var lerpStaticPosition :float = 303.0

func _ready() -> void:
	# set stats
	var stats :String = "STATS\n\n"
	
	var timeText :String = "%.2f" % Global.personalRecord
	if Global.personalRecord < 10.0:
		timeText = "0" + timeText
	timeText = timeText.left(5)
	
	if Global.personalRecord != 0.0:
		stats += "BEST TIME: " + timeText + " remaining\n\n"
	else:
		stats += "BEST TIME: UNKNOWN\n\n"
	
	if Global.bestClicks < 99999:
		stats += "BEST CLICKS: " + str(Global.bestClicks) + " clicks\n\n"
	else:
		stats += "BEST CLICKS: UNKNOWN\n\n"
	
	stats += "TIMES WON: " + str(Global.totalTimesWon) + "\n\n"
	stats += "TIMES LOST: " + str(Global.totalTimesLost)
	$stats/Label.text = stats


func _on_play_button_pressed() -> void:
	Global.setSeed = 0
	SceneTransitioner.transitionScene("res://main_scenes/game_screen.tscn")


func _on_daily_button_pressed() -> void:
	
	Global.setSeed = Global.getDayInt()
	SceneTransitioner.transitionScene("res://main_scenes/game_screen.tscn")


func _on_credits_button_pressed() -> void:
	var tween :Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Buttons,"position:x",-150.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($thing,"position:x",-210.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($credits,"position:x",160.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	lerpStaticPosition = 93.0
	$Logo.hide()

func _on_stats_button_pressed() -> void:
	var tween :Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Buttons,"position:x",-150.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($thing,"position:x",-210.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($stats,"position:x",160.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	lerpStaticPosition = 93.0
	$Logo.hide()


func _process(delta: float) -> void:
	$StaticBody2D.position.x = lerp($StaticBody2D.position.x,lerpStaticPosition,0.02)
	var i :float = sin( Time.get_ticks_msec()  * 0.01) * 0.02
	$Logo.scale = Vector2(i + 0.9,i + 0.9)
	$Logo.rotation = sin( Time.get_ticks_msec()  * 0.005) * 0.04

func _on_quit_button_pressed() -> void:
	if OS.has_feature("web"):
		return
	get_tree().quit()


## CREDIT BUTTONS ##

func _on_kaia_credit_button_pressed() -> void:
	Saving.open_site("https://kaiakairos.net/")

func _on_sage_credit_button_pressed() -> void:
	Saving.open_site("https://staggernight.com/")

func _on_jam_link_button_pressed() -> void:
	Saving.open_site("https://itch.io/jam/mccgdc-fall-game-jam")


func _on_jam_link_2_button_pressed() -> void:
	Saving.open_site("https://itch.io/jam/20-second-game-jam-2025")


func _on_credit_back_button_pressed() -> void:
	var tween :Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Buttons,"position:x",26.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($thing,"position:x",0.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($credits,"position:x",400.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	lerpStaticPosition = 303.0
	$Logo.show()


func _on_stat_back_button_pressed() -> void:
	var tween :Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Buttons,"position:x",26.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($thing,"position:x",0.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($stats,"position:x",400.0,0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	lerpStaticPosition = 303.0
	$Logo.show()
