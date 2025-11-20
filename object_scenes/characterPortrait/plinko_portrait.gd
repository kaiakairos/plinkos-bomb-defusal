extends AnimatedSprite2D


func setAnim(animName:String) -> void:
	if animName == animation:
		return
	play(animName)
