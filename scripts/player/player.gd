class_name Player
extends CharacterBody2D
@onready var animation_player : AnimationPlayer= $AnimationPlayer
@onready var sprite2d=$Sprite2D
@onready var swordArea:Area2D=$swordArea
@onready var hitboxArea:Area2D=$hitboxArea
@onready var healthBar:ProgressBar=$HealthBar
var inputVector:Vector2

var isAttacking
var attack_toggle: bool=false
#cooldown variables
var attack_cooldown=0.0
var damageCooldown=2
var attackable=true
var isRunning: bool=false
var wasRunning: bool=false
var ritualCooldown=20

@export_category("movement")
@export var speed:float =3

@export_category("sword")
@export var sword_damage:int=20
@export var sword_range:float=0.4

@export_category("ritual")
@export var ritualDamage:int=1
@export var ritualInterval:float=30
@export var ritualScene:PackedScene

@export_category("life")
@export var baseDamageCooldown=0.5
@export var maxHealth:int=200
@export var health:int=200
@export var deathTemplate:PackedScene

signal  meat_colected (value:int)
signal  gold_colected (value:int)
func _ready():
	GameManager.player=self
	meat_colected.connect(func(value:int): GameManager.countMeat+=1)
	gold_colected.connect(func(value:int): GameManager.goldScore+=value)
func _process(delta)->void:
	#tentar ritual
	updateRitual(delta)
	#detectar dano
	updateHitboxDetection(delta)
	GameManager.playerPosition=position
	#chamada da função de leitura dos inputs
	inputs()
	#animações de movimento
	animatMove()
	#calculo do cooldown dos ataques
	cooldownCalcs(delta)
	#chamar função de ataque
	if Input.is_action_just_pressed("attack"):
		attack()
	#update Health bar
	healthBar.max_value=maxHealth
	healthBar.value=health
func _physics_process(delta):
	#modificar velocidade
	var target_velocity=inputVector*speed/delta
	if isAttacking:
		target_velocity*=0.25
	velocity=lerp(velocity,target_velocity,0.5)
	move_and_slide()

#função de cooldown de ataques do player e dos mobs
func cooldownCalcs(delta:float):
	if attack_cooldown>0:
		attack_cooldown-=delta
		if attack_cooldown<=0:
			isAttacking=false
			isRunning=false
			animation_player.play("idle")


#função com as animações de movimento
func animatMove():
	#tocar animação
	if !isAttacking:
		if wasRunning!=isRunning:
			if isRunning:	
				animation_player.play("run")
			else:
				animation_player.play("idle")
	#Girar sprite de acordo com a direção
	if inputVector.x>0:
		#demarcar flip h
		sprite2d.flip_h=false
		pass
	elif inputVector.x<0:
		#marcar flip h
		sprite2d.flip_h=true

#função com os inputs
func inputs()->void:
		#obter input
	inputVector=Input.get_vector("move_left","move_right","move_up","move_down",0.15)
	#atualizar o isRunning
	wasRunning=isRunning
	isRunning= not inputVector.is_zero_approx()
#funções de ataque
func attack()-> void:
	#cancelar ordem caso ja esteja atacando
	if isAttacking:
		return
	#chacagem do eixo do ataque
	if inputVector.y!=0:
		if inputVector.x==0:
			#tocar animação
			if inputVector.y<0:
				#attack side 1
				if !attack_toggle:
					animation_player.play("attack_up1")
				#attack side 2
				if attack_toggle:
					animation_player.play("attack_up2")
			if inputVector.y>0:
				#attack side 1
				if !attack_toggle:
					animation_player.play("attack_down1")
				#attack side 2
				if attack_toggle:
					animation_player.play("attack_down2")
		else:#attack side 1
			if !attack_toggle:
				animation_player.play("attack_side1")
			#attack side 2
			if attack_toggle:
				animation_player.play("attack_side2")
	else:
		#attack side 1
		if !attack_toggle:
			animation_player.play("attack_side1")
		#attack side 2
		if attack_toggle:
			animation_player.play("attack_side2")
	#Marcar ataque
	isAttacking=true
	attack_cooldown=0.6
	attack_toggle= !attack_toggle
func dealDamage():
	var bodies = swordArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy=body
			var directionToEnemy = (enemy.position-position).normalized()
			var attackdirection: Vector2
			if sprite2d.flip_h:
				attackdirection=Vector2.LEFT
			else:
				attackdirection=Vector2.RIGHT
			if inputVector.y<0:
				attackdirection=Vector2.UP
			elif inputVector.y>0:
				attackdirection=Vector2.DOWN
			var dot_product=directionToEnemy.dot(attackdirection)
			if dot_product>=0.4:
				enemy.damage(sword_damage,attackdirection)
			
			pass
		pass
	#var enemies=get_tree().get_nodes_in_group("enemies")
	#for enemy in enemies:
		#enemy.damage(sword_damage)
#funções de dano
func updateHitboxDetection(delta:float):
	damageCooldown-=delta
	if damageCooldown>=0:
		return
	damageCooldown=baseDamageCooldown
	var bodies = hitboxArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy=body
			var damage_amount=enemy.baseDamage
			damage(damage_amount)
func damage(amount:int):
	if health<=0:
		return
	#computar dano
	health-=amount
	# piscar node
	modulate=Color.RED
	var tween=create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	if health<=0:
		death()
func death():
	if deathTemplate:
		var	deathObject=deathTemplate.instantiate()
		deathObject.position=position
		get_parent().add_child(deathObject)
	queue_free()
	print("você morreu")
	GameManager.end_game()
#função de cura
func  heal(amount:int)->int:
	health+=amount
	if health>=maxHealth:
		health=maxHealth
	return health
#função do ritual
func updateRitual(delta:float):
	#Atualizar cooldown
	ritualCooldown-=delta
	if ritualCooldown>=0:
		return
	ritualCooldown=ritualInterval
	#Criar ritual
	var ritual=ritualScene.instantiate()
	ritual.ritualDamage=ritualDamage
	add_child(ritual)
