extends Control

export var zoom_in_scale :float = 6.0
export var default_scale :float = 4.0

onready var MainVPC :ViewportContainer = $"%ViewportContainer"

onready var btn_ZoomIn :Button = $"%btn_ZoomIn"
onready var btn_ZoomOut :Button = $"%btn_ZoomOut"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	btn_ZoomIn.connect("pressed", self, "zoom_in")
	btn_ZoomOut.connect("pressed", self ,"zoom_out")


func zoom_in() -> void:
	var tween :SceneTreeTween = create_tween()
	tween.stop()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(
		MainVPC,
		"rect_scale",
		Vector2(zoom_in_scale, zoom_in_scale),
		0.5
	)
	tween.tween_property(
		MainVPC,
		"rect_position",
		calculate_new_position(),
		0.5
	)
	tween.play()
	yield(tween, "finished")


func zoom_out() -> void:
	var tween :SceneTreeTween = create_tween()
	tween.stop()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_parallel(true)
	tween.tween_property(
		MainVPC,
		"rect_scale",
		Vector2(default_scale, default_scale),
		0.5
	)
	tween.tween_property(
		MainVPC,
		"rect_position",
		Vector2.ZERO,
		0.5
	)
	tween.play()
	yield(tween, "finished")


func calculate_new_position() -> Vector2:
	# I split this into two separate pieces to make it easier to modify positioning if you'd like
	# The commented out section is the same math, just all at once
	var new_x :float = ProjectSettings.get("display/window/size/width")
	new_x = ((new_x * zoom_in_scale) / (2.0 * default_scale)) - new_x
	
	var new_y :float = ProjectSettings.get("display/window/size/height")
	new_y = ((new_y * zoom_in_scale) / (2.0 * default_scale)) - new_y
	
	var new_position :Vector2 = Vector2(new_x, new_y)
	
#	var window_size :Vector2 = Vector2(
#		ProjectSettings.get("display/window/size/width"),
#		ProjectSettings.get("display/window/size/height")
#		)
		
#	var new_position :Vector2 = ((window_size * zoom_in_scale) / (2.0 * default_scale)) - window_size
	
	return new_position
	
	




## THESE ARE NOT USED IN THIS PROJECT, BUT I LEFT THEM IN BECAUSE YOU MIGHT FIND THEM USEFUL ELSEWHERE

# Returns the aspect ratio of the project
#func get_aspect_ratio() -> Vector2:
#	var aspect_ratio :Vector2
#	var gcf :float = get_gcf(
#		ProjectSettings.get("display/window/size/width"),
#		ProjectSettings.get("display/window/size/height")
#		)
#	aspect_ratio.x = ProjectSettings.get("display/window/size/width") / gcf
#	aspect_ratio.y = ProjectSettings.get("display/window/size/height") / gcf
#	print("Aspect ratio: ", aspect_ratio)
#	return aspect_ratio


# Returns the greatest common factor (GCF) of two ints
#func get_gcf(a :int, b :int) -> float:
#	if b == 0:
#		return float(a)
#	return get_gcf(b , a % b)
