ffcd() {
    local dir=$(fdfind --type d --hidden . / | fzf)
    cd "$dir"
}
