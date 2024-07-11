class_name Entity
extends Node2D
## Base class for most entities of the game
## 
## Supports a destroyed flag and the capability to register components

var destroyed: bool = false
var components: Dictionary = {}

func register_component(comp_name: String, component: Node):
	components[comp_name] = component

func get_component(comp_name: String) -> Node:
	return components.get(comp_name)
