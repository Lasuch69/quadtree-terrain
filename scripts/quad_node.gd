class_name QuadNode
extends RefCounted

var rect: Rect2
var depth: int

func _init(rect: Rect2, depth: int) -> void:
	self.rect = rect
	self.depth = depth
