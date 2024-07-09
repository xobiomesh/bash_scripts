
#!/bin/bash

# Define the destination directory
destination_dir="/path/to/destination/directory"

# Open a dialog for the user to select files
files_to_copy=$(zenity --file-selection --multiple --title="Select files to copy" --separator=" ")

# Check if the user selected files
if [ -z "$files_to_copy" ]; then
    echo "No files selected."
    exit 1
fi

# Loop through each selected file and copy it to the destination directory
IFS=' ' read -r -a files <<< "$files_to_copy"
for file in "${files[@]}"; do
    cp "$file" "$destination_dir"
    echo "Copied $(basename "$file") to $destination_dir"
done
