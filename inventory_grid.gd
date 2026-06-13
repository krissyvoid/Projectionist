extends GridContainer

@onready var game_node = get_node("/root/Game")
@onready var inventory_node = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")
#don't know what this is for
#@onready var InvCell = load("res://scenes/inv_cell.tscn")
var inventory_dict := {}   # item_name → node instance

func add (item: String) -> void:
	var ItemPath: String = game_node.items_list[item]["Scene"]
	var ItemScene = load(ItemPath)
	var ItemInstance = ItemScene.instantiate()
	add_child(ItemInstance)
	inventory_dict[item] = ItemInstance
	

func remove(item: String) -> void:
	if inventory_dict.has(item):
		inventory_dict[item].queue_free()
		inventory_dict.erase(item)

## Removes existing items (and placeholders) from the InventoryGrid
## and populates it with new item scenes.
func build() -> void:
	## Removes existing items in the grid
	for child in inventory_node.get_children():
		inventory_node.remove_child(child)
	## Add the contents of the inventory dictionary (in Game.gd) to InventoryGrid
	for item in game_node.inventory:
		var ItemPath: String = game_node.items_list[item]["Scene"]
		var ItemScene = load(ItemPath)
		var ItemInstance = ItemScene.instantiate()
		add_child(ItemInstance)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
