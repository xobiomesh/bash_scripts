#!/bin/bash

# Function to select directory using fzf
select_directory() {
    echo "Select the $1 directory (starting search from root directory)..."
    selected_dir=$(find / -type d 2>/dev/null | fzf --height 40% --border --prompt="Select $1 directory: ")
    if [ -z "$selected_dir" ]; then
        echo "No directory selected. Exiting..."
        exit 1
    fi
    echo "Selected $1 directory: $selected_dir"
    echo "$selected_dir"
}

# Prompt user to select source and destination directories
echo "Prompting for source directory..."
source_dir=$(select_directory "source")
echo "Source directory selected: $source_dir"

echo "Prompting for destination directory..."
destination_dir=$(select_directory "destination")
echo "Destination directory selected: $destination_dir"

# Verbose info about the action being taken
echo "Copying the last 5 modified files from $source_dir to $destination_dir..."

# Get the last 5 modified files in the source directory
files_to_copy=$(find "$source_dir" -type f -printf "%T@ %p\n" | sort -n | tail -n 5 | cut -d' ' -f2-)

# Check if no files are found
if [ -z "$files_to_copy" ]; then
    echo "No files found in the source directory. Exiting..."
    exit 1
fi

# Loop through each file and copy it to the destination directory
while IFS= read -r file; do
    src_file="$file"
    dest_file="$destination_dir/$(basename "$file")"
    
    # Handle files with special characters
    cp -- "$src_file" "$dest_file"
    
    echo "Copied $(basename "$file") to $destination_dir"
done <<< "$files_to_copy"

echo "File copying completed."
