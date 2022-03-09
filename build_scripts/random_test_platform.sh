#!/bin/bash
# Array with expressions
expressions=("debian")

# Seed random generator
RANDOM=$$$(date +%s)

# Loop loop loop loop loop loop ...
    # Get random expression...
    selectedexpression=${expressions[$RANDOM % ${#expressions[@]} ]}
    # Write to Shell
    echo $selectedexpression



