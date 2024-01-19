class_name reactor 
extends subsystem

# static
var s_max_output: int # kW
var s_battery_capacity: int # kWh
var s_max_temp: int # °C

# dynamic
var d_output: float # kW
var d_battery: float # kWh
var d_temp: float # °C
