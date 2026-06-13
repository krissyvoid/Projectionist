extends Label

@onready var mouse_ray: RayCast2D = %MouseRay

var mouse_target : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	mouse_target = mouse_ray.get_collider()
	if mouse_target != null:
		var target_string = str(mouse_target)
		text = target_string
		var trim_length = target_string.find(":")
		#print("Trim length: ", trimlength)
		var target_trim = text.erase(trim_length, 99)
		text = target_trim
	else:
		text = "Nothing"
	
	
