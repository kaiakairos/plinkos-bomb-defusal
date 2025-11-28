extends Node


var setSeed :int = 0

var personalRecord :float = 0.0

var lastDayPlayed :int = 0
var bestDayTime :float = 0.0

func _ready() -> void:
	var d :Dictionary= Saving.read_save("scores")
	if d == {}:
		return # no save created yet
	
	personalRecord = d["personalRecord"]
	lastDayPlayed = d["lastDayPlayed"]
	bestDayTime = d["bestDayTime"]

func save() -> void:
	Saving.write_save("scores",{"personalRecord":personalRecord,"lastDayPlayed":lastDayPlayed,"bestDayTime":bestDayTime})

func getDayInt() -> int:
	var datetime :Dictionary = Time.get_datetime_dict_from_system()
	return int( str(datetime.day) + str(datetime.month) + str(datetime.year) )
