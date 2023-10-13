extends KinematicBody2D

signal change_direction(direction)
signal velocity_changed(velocity)
signal action_pressed()
signal hit(damage)
signal position_changed(position)

var left:bool = false
var right:bool = false
var up:bool = false
var down:bool = false
var move_axis:Vector2 = Vector2() setget set_move_axis
var speed:float = 90
var velocity:Vector2 = Vector2() setget set_velocity
var push_velocity:Vector2 = Vector2()
var bloc_move = false
var disabled = false setget set_disabled
onready var start_pos = global_position


onready var tween:Tween = $Sprite/Tween
onready var sprite:AnimatedSprite = $Sprite

func _process(_delta):
	if bloc_move:
		return
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	self.move_axis = Vector2(-int(left)+int(right),-int(up)+int(down))
	if Input.is_action_pressed("action"):
		emit_signal("action_pressed")
		bloc_move = true
		self.move_axis = Vector2.ZERO
		self.velocity = Vector2.ZERO


func _physics_process(_delta):
	push_velocity = push_velocity.linear_interpolate(Vector2.ZERO,0.1)
	velocity = move_and_slide((velocity+push_velocity).floor())
	emit_signal("position_changed",global_position)


func set_direction(direction):
	emit_signal("change_direction",direction)


func set_move_axis(v):
	if disabled:
		return
	if move_axis != v:
		if v.length():
			emit_signal("change_direction",v)
	self.velocity = move_axis*speed
	move_axis = v


func set_velocity(v):
	velocity = v
	emit_signal("velocity_changed",velocity)


func _on_ActionTime_timeout():
	bloc_move = false


func hit(damage = 1):
	emit_signal("hit",damage)
	hit_fx()


func death():
	self.disabled = true
	sprite.animation = "Death"
	yield(get_tree().create_timer(0.5,false),"timeout")
	get_tree().call_group("Hud","revive")
	reset()


func reset():
	global_position = start_pos
	self.disabled = false


func push(from,force):
	push_velocity = (global_position-from).normalized()*force


func hit_fx():
# warning-ignore:return_value_discarded
	tween.interpolate_property(sprite,"scale",Vector2(2,2),Vector2.ONE,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	tween.interpolate_property(sprite,"modulate",Color(50,50,50),Color.white,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$SndHit.play()
# warning-ignore:return_value_discarded
	tween.start()


func set_disabled(v):
	disabled = v
	set_process(!v)
	set_physics_process(!v)
