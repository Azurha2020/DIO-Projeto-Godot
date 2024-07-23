extends Node
signal  game_over
var playerPosition: Vector2
var player:Player
var is_gameOver=false
var countMeat:int=0
var countMonsters:int=0
var goldScore=0
var timerStamp:float=0.0
var timerString:String
func _process(delta):
	timerStamp+=delta
	var timer_seconds:int= floori(GameManager.timerStamp)
	var seconds:int= timer_seconds%60
	var minutes:int= timer_seconds/60
	timerString="%02d:%02d"%[minutes,seconds]
	
func  end_game():
	if is_gameOver:return
	is_gameOver=true
	game_over.emit()
func  reset():
	timerStamp=0
	player=null
	playerPosition=Vector2.ZERO
	is_gameOver=false
	countMonsters=0
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)

