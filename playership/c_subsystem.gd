class_name subsystem
extends Control

# static
var s_idle_thermal: int # °C
var s_max_thermal: int # °C

# dynamic
var d_thermal: int # °C (excess heat produced by the subsystem)

# interface text
var text_off: String = "Off"
var text_deac: String = "Deactivating"
var text_init: String = "Initialising"
var text_op: String = "Operational"
var text_mal: String = "Malfunction"

func wait(seconds: float) -> void:
  await get_tree().create_timer(seconds).timeout
