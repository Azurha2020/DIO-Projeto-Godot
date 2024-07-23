class_name GameOverUI
extends CanvasLayer
@onready var timeLabel:Label=%"time label"
@onready var monstersLabel:Label=%"monsters Label"
@export var restartDelay:float=15
var restartCountdown
var timeSurvived:String
func  _ready():
	timeLabel.text=GameManager.timerString
	monstersLabel.text=str(GameManager.countMonsters)
	restartCountdown=restartDelay
func _process(delta):
	restartCountdown-=delta
	if restartCountdown<=0:
		restartGame()

func restartGame():
	GameManager.reset()
	get_tree().reload_current_scene()
	pass
