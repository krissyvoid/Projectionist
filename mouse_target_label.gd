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
		var targetstr = str(mouse_target)
		text = targetstr
		var trimlength = targetstr.find(":")
		#print("Trim length: ", trimlength)
		var targettrim = text.erase(trimlength, 99)
		text = targettrim
	else:
		text = "Nothing"
	
	
