extends Area2D

signal hit_something

func _on_body_entered(body):
	body.hit(owner.damage)
	emit_signal("hit_something")


func _on_area_entered(area):
	area.owner.hit(owner.damage)
	emit_signal("hit_something")
