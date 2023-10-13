extends AnimatedSprite

var char_direction = "D" setget set_char_direction
var current_anim = "Idle" setget set_current_anim
onready var tween = $Tween 

func update_anim():
	animation = current_anim+char_direction


func _on_change_direction(direction):
	var angle = floor((rad2deg(direction.angle()))/90)*90
	match angle:
		90.0:
			self.char_direction = "D"
		-90.0,-180.0:
			self.char_direction = "U"
		180.0:
			self.char_direction = "L"
		0.0:
			self.char_direction = "R"


func _on_velocity_changed(velocity):
	if $ActionTime.time_left:
		return
	elif velocity.length() > 0:
		self.current_anim = "Walk"
	else:
		self.current_anim = "Idle"


func set_char_direction(v):
	char_direction = v
	update_anim()


func set_current_anim(v):
	current_anim = v
	update_anim()


func action_started():
	$ActionTime.start()
	self.current_anim = "Attack"


func _on_ActionTime_timeout():
	self.current_anim = "Walk"

func _on_hit(damage):
	tween.interpolate_property(self,"modulate",Color(50,50,50),Color.white,0.1,Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.start()
