#!/bin/bash

CONFIG_H="$HOME/.local/suckless/dwm/config.h"

# Extract keybindings from config.h
keybindings=$(awk '
    /\/\*.*\*\// { next } # Skip block comments
    /\{.*\,.*\,.*\}.*\/\// {
        # Split the line into keybinding part and description part
        split($0, parts, "//");
        keybinding = parts[1];
        description = parts[2];
        
        # Remove curly braces and commas, and trim leading/trailing spaces
        gsub("[{}]", "", keybinding);
        gsub(",", "", keybinding);
        gsub("^[[:space:]]+|[[:space:]]+$", "", keybinding);
        gsub("^[[:space:]]+|[[:space:]]+$", "", description);
        
        # Split the keybinding part into components
        split(keybinding, key_parts, "[[:space:]]+");
        modifier = key_parts[1];
        key = key_parts[2];
        
        # Combine modifier and key for output
        keybinding_combined = modifier "+" key;
        
        # Print the formatted output
        print keybinding_combined "\t" description;
    }
' $CONFIG_H)

# Escape ampersands for yad
keybindings_formatted=$(echo "$keybindings" | sed 's/&/\&amp;/g')

# Create a temporary file for yad input
tempfile=$(mktemp)

# Write the formatted keybindings to the temporary file
echo "$keybindings_formatted" > "$tempfile"

# Display keybindings using yad --list
yad --list --title="Keybindings" --column="Keybinding" --column="Description" --width=600 --height=400 --no-headers < "$tempfile"

# Clean up the temporary file
rm "$tempfile"

## Extract keybindings from config.h
#keybindings=$(awk '
#    /\/\*.*\*\// { next } # Skip block comments
#    /\{.*\,.*\,.*\}.*\/\// {
#        # Split the line into keybinding part and description part
#        split($0, parts, "//");
#        keybinding = parts[1];
#        description = parts[2];
#        
#        # Remove curly braces and commas, and trim leading/trailing spaces
#        gsub("[{}]", "", keybinding);
#        gsub(",", "", keybinding);
#        gsub("^[[:space:]]+|[[:space:]]+$", "", keybinding);
#        gsub("^[[:space:]]+|[[:space:]]+$", "", description);
#        
#        # Split the keybinding part into components
#        split(keybinding, key_parts, "[[:space:]]+");
#        modifier = key_parts[1];
#        key = key_parts[2];
#        
#        # Combine modifier and key for output
#        keybinding_combined = modifier "+" key;
#        
#        # Print the formatted output
#        print keybinding_combined "\t" description;
#    }
#' $CONFIG_H)
#
## Escape ampersands for yad
#keybindings_formatted=$(echo "$keybindings" | sed 's/&/\&amp;/g')
#
## Display keybindings using yad
#yad --text-info --title="Keybindings" --text="$keybindings_formatted" --width=600 --height=400
