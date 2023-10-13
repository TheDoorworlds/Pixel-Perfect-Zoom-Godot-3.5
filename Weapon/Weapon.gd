extends AnimatedSprite

signal attack_end

var direction = 0 setget set_direction
export(int) var damage = 3 
onready var tween = $Tween


func _ready():
	disable_weapon()
	visible = false
	tween.connect("tween_all_completed",self,"attack_end")


func set_direction(v):
	direction = v.angle()-PI/2
	rotation = direction
	if v.y > 0:
		z_index = 0
	else:
		z_index = -1
		


func _on_change_direction(dir):
	self.direction = dir


func on_attack():
	visible = true
	var px = 0
	var py = 16
	var final_py = 10
	match(int(rad2deg(direction))):
		-90:
			px = -3
		90:
			px = 4
		0:
			px = -2
			py+= 6
		-180:
			px += 4
	$HitBox/Shape.set_deferred("disabled",false)
	tween.interpolate_property(self,"offset",Vector2(px,py),Vector2(px,final_py),0.2,Tween.TRANS_QUART,Tween.EASE_OUT_IN)
	tween.start()

func disable_weapon():
	$HitBox/Shape.set_deferred("disabled",true)

func attack_end():
	visible = false
	emit_signal("attack_end")
	disable_weapon()


func _on_hit_something():
	$ImpactFx.emitting = true

