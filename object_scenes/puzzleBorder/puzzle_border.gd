extends Node2D
class_name PuzzleBorder

@export var id :int = 0

var enabled :bool = false
signal opened(node:PuzzleBorder)

var lidVelocity :Vector2 = Vector2.ZERO
var lidRotationVel :float = 0.0

func _ready() -> void:
	set_process(false)
	$PopLid.pitch_scale = 1.33 + randf_range(-0.04,0.2)

func _process(delta: float) -> void:
	
	lidVelocity.y += 1600 * delta
	
	$Lid.position += lidVelocity * delta
	$Lid.rotate(lidRotationVel * delta)
	
	if $Lid.position.y > 500.0:
		set_process(false)

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if enabled:
		return
	if event is not InputEventMouseButton:
		return
	if event.button_index != 1:
		return
	if !event.pressed:
		return
	
	enabled = true
	emit_signal("opened",self)
	$PopLid.play()
	$ColorRect.hide()
	set_process(true)
	
	lidVelocity.y = randf_range(-200.0,-280.0)
	lidVelocity.x = randf_range(-200.0,200.0)
	lidRotationVel = randf_range(-4.0,4.0)
	$Lid.modulate.a = 0.5
	$Lid.z_index = 11

func disablePuzzle() -> void:
	$ColorRect.show()
	var tween :Tween= get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Mask/Door1,"position:x",0.0,0.2)
	tween.tween_property($Mask/Door2,"position:x",0.0,0.2)
	await tween.finished
	
	for i in range(6):
		$Mask/Door1.position.x = randi_range(-3,3)
		$Mask/Door1.position.y = randi_range(-3,2)
		$Mask/Door2.position.x = $Mask/Door1.position.x
		$Mask/Door2.position.y =$Mask/Door1.position.y
		await get_tree().process_frame
	for i in range(10):
		$Mask/Door1.position.x = randi_range(-1,1)
		$Mask/Door1.position.y = randi_range(-1,1)
		$Mask/Door2.position.x = $Mask/Door1.position.x
		$Mask/Door2.position.y =$Mask/Door1.position.y
		await get_tree().process_frame
	$Mask/Door1.position = Vector2.ZERO
	$Mask/Door2.position = Vector2.ZERO
