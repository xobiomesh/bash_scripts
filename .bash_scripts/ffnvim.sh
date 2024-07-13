
ffnvim() {
    if [ $# -eq 0 ]; then
        FILE=$(fdfind --type f --hidden --base-directory / | fzf)
        if [ -n "$FILE" ]; then
            echo "$FILE" | xclip -selection clipboard
            echo "Editing $FILE"
            nvim "$FILE"
        fi
    else
        echo "Editing new file: $@"
        nvim "$@"
    fi
}

