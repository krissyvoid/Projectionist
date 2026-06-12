extends Label

@onready var mouse_ray: RayCast2D = %MouseRay

var target : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#target = mouse_ray.get_collider()
	#text = str(target)
	#var trimlength = text.find(":")
	#text.set_length(trimlength)
	pass
