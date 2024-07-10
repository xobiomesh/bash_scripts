
ffmv() {
    # Prompt the user to select a file or directory using fzf
    ITEM=$(find / -type f -name ".*" -o -type f -name "*" -o -type d -name ".*" -o -type d -name "*" 2>/dev/null | fzf --prompt="Select file or directory to move: ")
    
    # If no item was selected, exit the function
    if [ -z "$ITEM" ]; then
        echo "No file or directory selected."
        return 1
    fi
    
    # Notify the user of the selected file or directory
    if [ -d "$ITEM" ]; then
        FILE_COUNT=$(find "$ITEM" -type f | wc -l)
        echo "Selected directory: $ITEM (contains $FILE_COUNT files)"
    else
        echo "Selected file: $ITEM"
    fi
    
    # Prompt the user for the destination
    read -p "Enter the destination path: " DEST
    
    # If no destination was provided, exit the function
    if [ -z "$DEST" ]; then
        echo "No destination path provided."
        return 1
    fi

    # Confirm the action
    echo "You have selected: $ITEM"
    echo "Destination: $DEST"
    read -p "Are you sure you want to move this to the destination? (y/N): " -n 1 -r
    echo    # move to a new line

    # If the user confirms, move the selected item
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -w "$ITEM" ] && [ -w "$(dirname "$DEST")" ]; then
            mv "$ITEM" "$DEST"
        else
            sudo mv "$ITEM" "$DEST"
        fi
        echo "Moved '$ITEM' to '$DEST'."
    else
        echo "Operation cancelled."
    fi
}
