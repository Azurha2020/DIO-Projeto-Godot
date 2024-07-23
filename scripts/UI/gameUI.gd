extends CanvasLayer

@onready var timerLabel:Label=%"timer Label"
@onready var meatLabel:Label=%"Meat Label"
@onready var goldLabel:Label=%"Gold label"
func _ready():
	GameManager.player.meat_colected.connect(on_meatCollected)
	GameManager.player.gold_colected.connect(on_goldCollected)
func _process(delta):
	
	
	timerLabel.text=GameManager.timerString
func on_goldCollected(value:int):
	goldLabel.text=str(GameManager.goldScore)
func on_meatCollected(healAmount:int):
	meatLabel.text=str(GameManager.countMeat)
