extends Node2D
@export var gameUI:CanvasLayer
@export var gameOverUITemplate:PackedScene
func triggerGameOver():
	#criar Game Over UI
	var gameOverUI:GameOverUI=gameOverUITemplate.instantiate()
	add_child(gameOverUI)
	#deletar GameUI
	if gameUI:
		gameUI.queue_free()
		gameUI=null
	
func _ready():
	GameManager.game_over.connect(triggerGameOver)
