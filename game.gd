extends Node2D

## Hello, Github, it's me

@onready var inventorynode = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")
@onready var inventory_test: RichTextLabel = %InventoryTest
@onready var mouse_ray: RayCast2D = %MouseRay
@onready var screen_control: Control = %ScreenControl

@onready var button_remove_plopcorn: Button = %ButtonRemovePlopcorn
@onready var button_remove_bip_soda: Button = %ButtonRemoveBipSoda
@onready var button_add_plopcorn: Button = %ButtonAddPlopcorn
@onready var button_add_bip_soda: Button = %ButtonAddBipSoda

static var mousetarget : Node # What node the mouse is currently over
var targetstr : String # That node as a string
var trimlength : int # The point in that string that begins the UID stuff
var targettrim : String # The short, human-readable name of what the mouse is over. Should be the same as in items_list key
var examinetarg : String # Examine variant of targettrim

const bordx : float = 64 # Popup borders on the left and right, px
const bordy : float = 64 # Popup borders on the top and bottom, px
var popuptime : float = 1.5 # How long a popup stays on screen for
var popuptimeout : bool = 0 # Is the popup command on timeout, to prevent spamming
var popuptimeoutlength : float = 0.5 # How long in seconds the timeout lasts


## ------------------------------------ ITEM AND INVENTORY DICTIONARIES ----------------------------
static var inventory := {
	"Bip": {"Name": "Bip Soda",
		"Scene": "res://scenes/inv_items/inv_bip_soda.tscn",
		"Image": "res://images/items/bip_soda.png",
		"Description": "32oz of delicious Bip!\nMmmmm, rat blood flavour"
		},
	"Plopcorn": {"Name": "Tub of Plopcorn",
		"Scene": "res://scenes/inv_items/inv_plopcorn.tscn",
		"Image": "res://images/items/plopcorn.png",
		"Description": "A big tub of fresh-ish plopcorn,\ngovered in goop"
		},
	"MugLove": {"Name": "Heart Mug",
		"Scene": "res://scenes/inv_items/inv_mug_love.tscn",
		"Image": "res://images/items/mugheart.png",
		"Description": "What's this doing here?"
		},	
}

static var items_list := {
	"Bip": {"Name": "Bip Soda",
		"Scene": "res://scenes/inv_items/inv_bip_soda.tscn",
		"Image": "res://images/items/bip_soda.png",
		"Description": "32oz of delicious Bip!\nMmmmm, rat blood flavour"
		},
	"Plopcorn": {"Name": "Tub of Plopcorn",
		"Scene": "res://scenes/inv_items/inv_plopcorn.tscn",
		"Image": "res://images/items/plopcorn.png",
		"Description": "A big tub of fresh-ish plopcorn,\ngovered in goop"
		},
	"MugLove": {"Name": "Heart Mug",
		"Scene": "res://scenes/inv_items/inv_mug_love.tscn",
		"Image": "res://images/items/mugheart.png",
		"Description": "What's this doing here?"
		},
	"Srench": {"Name": "Srench",
		"Scene": "res://player.tscn",
		"Image": "res://images/characters/spr_srench_glow_large.png",
		"Description": "Ahh! It's a srench!"
		},
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move MouseRay to mouse location
	mouse_ray.position = get_global_mouse_position()
	mouse_ray.target_position = Vector2(0.0,0.0)
	
	# Get mouse target's name as a string, trimmed of its UID
	mousetarget = mouse_ray.get_collider()
	if mousetarget != null:
		targetstr = str(mousetarget)
		trimlength = targetstr.find(":")
		targettrim = targetstr.erase(trimlength, 99)
	else:
		targettrim = "Nothing"



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rmb"):
		if targettrim != "Nothing" and !popuptimeout:
			examinetarg = targettrim
			examine(examinetarg)

## Get a popup with the target's description, if it is a valid target
func examine(target):
	popuptimeout = true
	await get_tree().create_timer(popuptimeoutlength).timeout.connect(func(): popuptimeout = false)
	var popup = preload("res://scenes/text_bubble.tscn")
	var instance = popup.instantiate()
	instance.text = items_list[target]["Description"]
	add_child(instance)
	var halfx = instance.size.x/2
	var halfy = instance.size.y/2
	instance.global_position = get_global_mouse_position() + Vector2 (-halfx,-92)
		
	# Keep popup within screen area
	if instance.global_position.x - halfx < bordx:
		instance.global_position.x = bordx
	elif instance.global_position.x + instance.size.x > (1920 - bordx):
		instance.global_position.x = (1920 - bordx) - instance.size.x
	if instance.global_position.y - instance.size.y < bordy:
		instance.global_position.y = bordy/2 + instance.size.y
	elif instance.global_position.y + halfy > 952.0:
		instance.global_position.y = (1080 - bordy) - halfy
		
	# Reparents label to ScreenControl (breaks style and popup removal, don't use)
	#var newparent = get_node("/root/Game/ScreenControl")
	#instance.reparent(newparent)
	
	# Wait popuptime seconds then remove the popup
	await get_tree().create_timer(popuptime).timeout.connect(func (): remove_child(instance))



## --------------------------------- INVENTORY CONTROLS -------------------------------------
func add_item_to_inv(item_name: String):
	inventory[item_name] = items_list[item_name]
	inventory[item_name]["Name"] = items_list[item_name]["Name"]
	inventory[item_name]["Scene"] = items_list[item_name]["Scene"]
	inventory[item_name]["Image"] = items_list[item_name]["Image"]
	inventory[item_name]["Description"] = items_list[item_name]["Description"]
	inventorynode.resetinventorygrid()
	inventory_test.refreshinventorytest()

func remove_item_from_inv(item_name: String):
	inventory.erase(item_name)
	inventorynode.resetinventorygrid()
	inventory_test.refreshinventorytest()

## Inventory adjustment test button controls
func _on_button_remove_bip_soda_pressed() -> void:
	remove_item_from_inv("Bip")
func _on_button_add_plopcorn_pressed() -> void:
	add_item_to_inv("Plopcorn")
func _on_button_add_bip_soda_pressed() -> void:
	add_item_to_inv("Bip")
func _on_button_remove_plopcorn_pressed() -> void:
	remove_item_from_inv("Plopcorn")
