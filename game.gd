extends Node2D

## Hello, Github, it's me

@onready var inventory_grid = get_node("/root/Game/ScreenControl/TrayBoxContainer/TrayHBoxContainerL/VBoxContainer/InventoryGrid")
@onready var inventory_test: RichTextLabel = %InventoryTest
@onready var mouse_ray: RayCast2D = %MouseRay
@onready var screen_control: Control = %ScreenControl

@onready var button_remove_plopcorn: Button = %ButtonRemovePlopcorn
@onready var button_remove_bip_soda: Button = %ButtonRemoveBipSoda
@onready var button_add_plopcorn: Button = %ButtonAddPlopcorn
@onready var button_add_bip_soda: Button = %ButtonAddBipSoda

static var mouse_target : Node # What node the mouse is currently over
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
static var inventory = ["MugLove"]

var _target_string : String # That node as a string
var _trim_length : int # The point in that string that begins the UID stuff
var _target_trim : String # The short, human-readable name of what the mouse is over. Should be the same as in items_list key
var _examine_target : String # Examine variant of targettrim

const _border_x : float = 64 # Popup borders on the left and right, px
const _border_y : float = 64 # Popup borders on the top and bottom, px
var _popup_time : float = 1.5 # How long a popup stays on screen for
var _popup_timeout : bool = 0 # Is the popup command on timeout, to prevent spamming
var _popup_timeout_length : float = 0.5 # How long in seconds the timeout lasts

## --------------------------------- INVENTORY CONTROLS -------------------------------------
func _inventory_add_item(item_name: String):
	if item_name not in inventory: 
		inventory.append(item_name)
		inventory_grid.add(item_name)
		#inventory_test.inventory_refresh_test()

func _inventory_remove_item(item_name: String):
	if item_name in inventory: 
		inventory.erase(item_name)
		inventory_grid.remove(item_name)
		#inventory_test.inventory_refresh_test()
	

## Get a popup with the target's description, if it is a valid target
func _examine(target):
	_popup_timeout = true
	get_tree().create_timer(_popup_timeout_length).timeout.connect(func(): _popup_timeout = false)
	var popup = preload("res://scenes/text_bubble.tscn")
	var instance = popup.instantiate()
	instance.text = items_list[target]["Description"]
	add_child(instance)
	var half_x = instance.size.x/2
	var half_y = instance.size.y/2
	instance.global_position = get_global_mouse_position() + Vector2 (-half_x,-92)
		
	# Keep popup within screen area
	if instance.global_position.x - half_x < _border_x:
		instance.global_position.x = _border_x
	elif instance.global_position.x + instance.size.x > (1920 - _border_x):
		instance.global_position.x = (1920 - _border_x) - instance.size.x
	if instance.global_position.y - instance.size.y < _border_y:
		instance.global_position.y = _border_y/2 + instance.size.y
	elif instance.global_position.y + half_y > 952.0:
		instance.global_position.y = (1080 - _border_y) - half_y
		
	# Reparents label to ScreenControl (breaks style and popup removal, don't use)
	#var newparent = get_node("/root/Game/ScreenControl")
	#instance.reparent(newparent)
	
	# Wait popuptime seconds then remove the popup
	get_tree().create_timer(_popup_time).timeout.connect(func (): remove_child(instance))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move MouseRay to mouse location
	mouse_ray.position = get_global_mouse_position()
	mouse_ray.target_position = Vector2(0.0,0.0)
	
	# Get mouse target's name as a string, trimmed of its UID
	mouse_target = mouse_ray.get_collider()
	if mouse_target != null:
		_target_string = str(mouse_target)
		_trim_length = _target_string.find(":")
		_target_trim = _target_string.erase(_trim_length, 99)
	else:
		_target_trim = "Nothing"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rmb"):
		if _target_trim != "Nothing" and !_popup_timeout:
			_examine_target = _target_trim
			_examine(_examine_target)



## Inventory adjustment test button controls
func _on_button_remove_bip_soda_pressed() -> void:
	_inventory_remove_item("Bip")
func _on_button_add_plopcorn_pressed() -> void:
	_inventory_add_item("Plopcorn")
func _on_button_add_bip_soda_pressed() -> void:
	_inventory_add_item("Bip")
func _on_button_remove_plopcorn_pressed() -> void:
	_inventory_remove_item("Plopcorn")
