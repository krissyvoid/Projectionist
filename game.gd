extends Node2D

@onready var inventorynode = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")
@onready var inventorytest = get_node("/root/Game/ScreenControl/TrayBoxContainer/HBoxContainer/InventoryTest")

@onready var button_remove_plopcorn: Button = %ButtonRemovePlopcorn
@onready var button_remove_bip_soda: Button = %ButtonRemoveBipSoda
@onready var button_add_plopcorn: Button = %ButtonAddPlopcorn
@onready var button_add_bip_soda: Button = %ButtonAddBipSoda


static var inventory := {
	"Bip": "res://scenes/inv_items/inv_bip_soda.tscn",
	"Plopcorn": "res://scenes/inv_items/inv_plopcorn.tscn",
}

static var items_list := {
	"Bip": "res://scenes/inv_items/inv_bip_soda.tscn",
	"Plopcorn": "res://scenes/inv_items/inv_plopcorn.tscn",
	"Heart Mug": "res://scenes/inv_items/inv_mug_love.tscn",	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Makes testing buttons activate the appropriate functions
	button_add_bip_soda.pressed.connect(add_item_to_inv.bind("Bip"))
	button_remove_bip_soda.pressed.connect(remove_item_from_inv.bind("Bip"))
	button_add_plopcorn.pressed.connect(add_item_to_inv.bind("Plopcorn"))
	button_remove_plopcorn.pressed.connect(remove_item_from_inv.bind("Plopcorn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Adds a specified item to the player inventory
func add_item_to_inv(item_name: String):
	if inventory.has(item_name) == false:
		var item_path = items_list[item_name]
		inventory[item_name] = item_path
		inventorynode.resetinventorygrid()
		inventorytest.refreshinventorytest()

## Removes a specified item to the player inventory
func remove_item_from_inv(item_name: String):
	if inventory.has(item_name):
		inventory.erase(item_name)
		inventorynode.resetinventorygrid()
		inventorytest.refreshinventorytest()
