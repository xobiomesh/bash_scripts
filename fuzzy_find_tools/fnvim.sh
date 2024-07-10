
fnvim() {
    if [ $# -eq 0 ]; then
        FILE=$(fdfind --type f --hidden | fzf)
        if [ -n "$FILE" ]; then
            echo "$FILE" | xclip -selection clipboard
            nvim "$FILE"
        fi
    else
        nvim "$@"
    fi
}
