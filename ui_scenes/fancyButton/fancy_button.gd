@tool
extends Node2D

signal buttonPressed

@export var buttonText :String = "PENIS"
@export var patchMargin :int = 3

var big :int = 0
var isHovering :bool = false

func _ready() -> void:
	
	$WhiteLabel.text = buttonText
	$Mask/NinePatchRect/BlackLabel.text = buttonText
	
	big = $Mask/NinePatchRect/BlackLabel.label_settings.font.get_string_size( $Mask/NinePatchRect/BlackLabel.text ).x
	$Mask/NinePatchRect.size.x = big + ( patchMargin * 2 )
	$Button.size.x = big + ( patchMargin * 2 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		$WhiteLabel.text = buttonText
		return
	
	if isHovering:
		$Mask.position.x = lerp($Mask.position.x,big + ( patchMargin * 2 ) - 190.0,0.2)
	else:
		$Mask.position.x = lerp($Mask.position.x,-203.0,0.2)
	
	$Mask.position.x = round($Mask.position.x)
	
	$Mask/NinePatchRect.position.x = ($Mask.position.x * -1) - patchMargin
	


func _on_button_mouse_entered() -> void:
	isHovering = true
	$hover.play()


func _on_button_mouse_exited() -> void:
	isHovering = false


func _on_button_button_down() -> void:
	$Mask.position.y = -6.0
	$Mask.modulate = Color.GRAY
	$clicked.play()

func _on_button_button_up() -> void:
	$Mask.position.y = -7.0
	$Mask.modulate = Color.WHITE


func _on_button_pressed() -> void:
	
	if SceneTransitioner.screenTransitioning:
		return
	
	emit_signal("buttonPressed")
