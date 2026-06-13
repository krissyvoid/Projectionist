extends GridContainer

@onready var game_node = get_node("/root/Game")
@onready var inventory_node = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")
#don't know what this is for
#@onready var InvCell = load("res://scenes/inv_cell.tscn")
var _inventory_dict := {}   # item_name → node instance

func add (item: String) -> void:
	var item_path: String = game_node.items_list[item]["Scene"]
	var item_scene = load(item_path)
	var item_instance = item_scene.instantiate()
	add_child(item_instance)
	_inventory_dict[item] = item_instance
	
func remove(item: String) -> void:
	if _inventory_dict.has(item):
		_inventory_dict[item].queue_free()
		_inventory_dict.erase(item)

## Removes existing items (and placeholders) from the InventoryGrid
## and populates it with new item scenes.
func build() -> void:
	## Removes existing items in the grid
	for child in inventory_node.get_children():
		inventory_node.remove_child(child)
	## Add the contents of the inventory dictionary (in Game.gd) to InventoryGrid
	for item in game_node.inventory:
		var item_path: String = game_node.items_list[item]["Scene"]
		var item_scene = load(item_path)
		var item_instance = item_scene.instantiate()
		add_child(item_instance)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
