extends Node

var score: int = 0
var health: int
var high_score: int = 0
var freeze: bool = false


func _ready():
	randomize()

