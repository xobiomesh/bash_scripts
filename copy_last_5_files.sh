
#!/bin/bash

# Prompt the user to select the source directory using fzf
echo "Select the source directory:"
source_dir=$(find / -type d 2>/dev/null | fzf)

# Check if a source directory was selected
if [ -z "$source_dir" ]; then
    echo "No source directory selected. Exiting."
    exit 1
fi

# Prompt the user to select the destination directory using fzf
echo "Select the destination directory:"
destination_dir=$(find / -type d 2>/dev/null | fzf)

# Check if a destination directory was selected
if [ -z "$destination_dir" ]; then
    echo "No destination directory selected. Exiting."
    exit 1
fi

# Get the last 5 modified files in the source directory
files_to_copy=$(ls -t "$source_dir" | head -n 5)

# Loop through each file and copy it to the destination directory
for file in $files_to_copy; do
    cp "$source_dir/$file" "$destination_dir"
    echo "Copied $file to $destination_dir"
done

