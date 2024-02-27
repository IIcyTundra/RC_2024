@tool
extends AspectRatioContainer

onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	if not grid_container.is_connected("sort_children", self, "fix_ratio"):
		# warning-ignore:return_value_discarded
		grid_container.connect("sort_children", self, "fix_ratio")

func fix_ratio() -> void:
	var columns := float(grid_container.columns)
	var rows := ceil(grid_container.get_child_count() / columns)
	ratio = columns / rows
	property_list_changed_notify()
