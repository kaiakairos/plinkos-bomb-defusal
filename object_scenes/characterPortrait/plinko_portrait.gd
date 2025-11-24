extends AnimatedSprite2D

@export var gradient :Gradient

func setAnim(animName:String) -> void:
	if animName == animation:
		return
	play(animName)

func setBGColor(color:Color) -> void:
	$ColorRect.color = color

func _process(delta: float) -> void:
	if get_parent().timerTicking:
		$ColorRect.color = gradient.sample(1.0 - (get_parent().timer - float(int(get_parent().timer))))
	else:
		setBGColor(Color(0.21, 0.21, 0.21, 1.0))
