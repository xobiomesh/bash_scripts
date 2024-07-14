
# Fuzzy Finder Commands

## `fcd` Alias

### Purpose:
This alias allows you to change directories using `fzf` for fuzzy finding.

### Command:
```sh
alias fcd='cd "$(fdfind . --type d | fzf)"'
```

### Components:
- `fdfind . --type d`: Uses `fdfind` (a faster alternative to `find`, also known as `fd`) to search for directories starting from the current directory.
- `| fzf`: Pipes the output of `fdfind` into `fzf`, providing a fuzzy search interface.
- `cd "$( ... )"`: Changes to the directory selected from `fzf`.

### Usage:
Simply type `fcd` in the terminal, and it will present you with a list of directories to choose from using `fzf`. Once you select a directory, it will change to that directory.

## `ffcd` Function

### Purpose:
This function allows you to change directories using `fzf` for fuzzy finding, with the default search starting from the root directory (`/`).

### Command:
```sh
ffcd() {
    local dir
    dir=$(find ${1:-/} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
```

### Components:
- `find ${1:-/} -type d 2> /dev/null`: Uses the standard `find` command to search for directories, starting from the root directory (`/`) by default if no argument is provided. Errors are redirected to `/dev/null`.
- `| fzf +m`: Pipes the output of `find` into `fzf`, providing a fuzzy search interface. The `+m` option enables multi-select mode.
- `local dir`: Declares a local variable `dir` to store the selected directory.
- `&& cd "$dir"`: Changes to the directory selected from `fzf`.

### Usage:
To use the function, simply type `ffcd` in the terminal:
```sh
ffcd
```
This will list all directories starting from the root directory (`/`) and change to the selected directory.

If you want to start the search from a specific directory, provide an argument:
```sh
ffcd /path/to/start
```
This will list directories starting from `/path/to/start` and change to the selected directory.

## `move_with_fzf` Function

### Purpose:
This function uses `fzf` to select a file or directory and move it to another location.

### Command:
```sh
move_with_fzf() {
    local item dest
    item=$(find / -type f -o -type d 2>/dev/null | fzf --prompt="Select file or directory to move: ")
    
    if [ -z "$item" ]; then
        echo "No file or directory selected."
        return 1
    fi
    
    if [ -d "$item" ]; then
        local file_count
        file_count=$(find "$item" -type f | wc -l)
        echo "Selected directory: $item (contains $file_count files)"
    else
        echo "Selected file: $item"
    fi
    
    read -p "Enter the destination path: " dest
    
    if [ -z "$dest" ]; then
        echo "No destination path provided."
        return 1
    fi
    
    echo "You have selected: $item"
    echo "Destination: $dest"
    read -p "Are you sure you want to move this to the destination? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -w "$item" ] && [ -w "$(dirname "$dest")" ]; then
            mv "$item" "$dest"
        else
            sudo mv "$item" "$dest"
        fi
        echo "Moved '$item' to '$dest'."
    else
        echo "Operation cancelled."
    fi
}
```

### Usage:
To use the function, simply type `move_with_fzf` in the terminal:
```sh
move_with_fzf
```
This will launch `fzf`, allowing you to select a file or directory to move. After selection, it will prompt you to enter the destination path and confirm the action before moving the item. If necessary, it will use `sudo` for the `mv` command.
