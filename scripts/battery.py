#!/usr/bin/env python3

import os

# Battery status script for i3blocks

BAT_PATH = "/sys/class/power_supply/BAT0"  # Adjust this path based on your system
CAPACITY = int(open(os.path.join(BAT_PATH, "capacity"), "r").read().strip())
STATUS = open(os.path.join(BAT_PATH, "status"), "r").read().strip()

# Determine the color and symbol based on battery status
if STATUS == "Charging":
    COLOR = "#00FF00"  # Green when charging
    SYMBOL = ""       # Unicode symbol for charging
else:
    COLOR = "#FF0000"  # Red when discharging
    SYMBOL = ""       # Unicode symbol for battery

# Print the battery status in the format suitable for i3blocks
print(f"{SYMBOL} {CAPACITY}%")
print(COLOR)
