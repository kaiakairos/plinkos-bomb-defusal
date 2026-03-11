extends Node


var setSeed :int = 0

var personalRecord :float = 0.0
var totalTimesWon :int = 0
var bestClicks :int = 99999999

var lastDayPlayed :int = 0
var bestDayTime :float = 0.0

var totalTimesLost :int = 0

signal toggleFullscreen(isFullscreen:bool)

func _ready() -> void:
	var d :Dictionary= Saving.read_save("scores")
	if d == {}:
		return # no save created yet
	
	personalRecord = d["personalRecord"]
	lastDayPlayed = d["lastDayPlayed"]
	bestDayTime = d["bestDayTime"]
	totalTimesWon = d["totalTimesWon"]
	bestClicks = d["bestClicks"]
	totalTimesLost = d["totalTimesLost"]

func save() -> void:
	Saving.write_save("scores",{
		"personalRecord":personalRecord,
		"lastDayPlayed":lastDayPlayed,
		"bestDayTime":bestDayTime,
		"totalTimesWon":totalTimesWon,
		"bestClicks":bestClicks,
		"totalTimesLost":totalTimesLost,
	})

func getDayInt() -> int:
	var datetime :Dictionary = Time.get_datetime_dict_from_system()
	return int( str(datetime.day) + str(datetime.month) + str(datetime.year) )

func getDayString() -> String:
	var datetime :Dictionary = Time.get_datetime_dict_from_system()
	var string :String = ""
	match datetime.month:
		1: string = "Jan "
		2: string = "Feb "
		3: string = "Mar "
		4: string = "Apr "
		5: string = "May "
		6: string = "Jun "
		7: string = "Jul "
		8: string = "Aug "
		9: string = "Sep "
		10: string = "Oct "
		11: string = "Nov "
		12: string = "Dec "
	return string + str(datetime.day) + " " + str(datetime.year)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
		emit_signal("toggleFullscreen",is_window)
		
