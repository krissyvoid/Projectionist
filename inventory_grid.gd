extends GridContainer

@onready var gamenode = get_node("/root/Game")
@onready var inventorynode = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")
@onready var InvCell = load("res://scenes/inv_cell.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resetinventorygrid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Removes existing items (and placeholders) from the InventoryGrid
## and populates it with new item scenes.
func resetinventorygrid() -> void:
	## Removes existing items in the grid
	for child in inventorynode.get_children():
		print("Removing child from InventoryGrid")
		inventorynode.remove_child(child)
	
	## Declare which items are being added
	for key in gamenode.inventory:
		print("Adding ", key, " to inventory.")
	## Add the contents of the inventory dictionary (in Game.gd) to InventoryGrid
	for value in gamenode.inventory:
		var ItemPath: String = gamenode.inventory[value]["Scene"]
		print("ItemPath is ", ItemPath)
		var ItemScene = load(ItemPath)
		var ItemInstance = ItemScene.instantiate()
		add_child(ItemInstance)
		
