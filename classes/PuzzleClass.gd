extends Node2D
class_name Puzzle

signal puzzleComplete(node:Puzzle)
var puzzleID :int = 0
var puzzleEnabled :bool = false

var rand :RandomNumberGenerator

var game :GameScreen

func enablePuzzle() -> void:
	puzzleEnabled = true
	print("puzzleEnabled!")
	onPuzzleEnabled()

func onPuzzleEnabled() -> void:
	pass

func winPuzzle() -> void:
	puzzleEnabled = false
	emit_signal("puzzleComplete",self)
