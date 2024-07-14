#!/bin/bash

# Function to remove a selected file or directory interactively using fdfind and fzf
ffrm() {
    # Correctly specify the type for both files and directories
    ITEM=$(fdfind --hidden --type f --type d . / | fzf --prompt="Select file or directory to remove: ")
    
    if [ -z "$ITEM" ]; then
        echo "No file or directory selected."
        return 1
    fi
    
    echo "You have selected: $ITEM"
    read -p "Are you sure you want to remove this? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -d "$ITEM" ]; then
            # Using sudo to ensure permissions for system-wide directory removal
            sudo rm -r "$ITEM"
            echo "Directory '$ITEM' removed."
        else
            # Using sudo for file removal as it might be protected
            sudo rm "$ITEM"
            echo "File '$ITEM' removed."
        fi
    else
        echo "Operation cancelled."
    fi
}


