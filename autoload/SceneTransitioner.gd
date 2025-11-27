extends Node

var rect :ColorRect 

var screenTransitioning :bool = false

func _ready() -> void:
	rect = ColorRect.new()
	rect.size = Vector2(420.0,16.0)
	rect.position = Vector2(-10.0,-24.0)
	rect.z_index = 4000
	rect.color = Color.BLACK
	add_child(rect)


func transitionScene(fileString:String) -> void:
	
	screenTransitioning = true
	
	var tween1 :Tween = get_tree().create_tween()
	tween1.tween_property(rect,"size:y",326.0,0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	await tween1.finished
	
	get_tree().change_scene_to_file(fileString)
	await get_tree().create_timer(0.2).timeout
	
	var tween2 :Tween = get_tree().create_tween()
	tween2.tween_property(rect,"position:y",326.0,0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	await tween2.finished
	
	rect.size.y = 16.0
	rect.position.y = -24.0
	
	screenTransitioning = false
