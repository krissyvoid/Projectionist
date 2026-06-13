extends Label

@onready var mouse_ray: RayCast2D = %MouseRay

var mousetarget : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mousetarget = mouse_ray.get_collider()
	if mousetarget != null:
		var targetstr = str(mousetarget)
		text = targetstr
		var trimlength = targetstr.find(":")
		#print("Trim length: ", trimlength)
		var targettrim = text.erase(trimlength, 99)
		text = targettrim
	else:
		text = "Nothing"
	
	
